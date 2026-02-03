import { JWT_SECRET, ADMIN_EMAIL, ADMIN_PASSWORD } from "../config/env.js";
import User from "../model/user.model.js";
import jwt from "jsonwebtoken";

const adminCreds = {
  email: ADMIN_EMAIL,
  password: ADMIN_PASSWORD,
  role: "ADMIN",
};

const generateToken = (payload) =>
  jwt.sign(payload, JWT_SECRET, { expiresIn: "1h" });

const setCookie = (res, token) =>
  res.cookie("token", token, { httpOnly: true, secure: true });

export const login = async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.json({
        success: false,
        message: "Email and password required",
      });
    }

    if (email === adminCreds.email && password === adminCreds.password) {
      const token = generateToken({ email, role: adminCreds.role });
      setCookie(res, token);
      return res.json({ success: true, message: "Successful", role: "ADMIN" });
    }

    const user = await User.findOne({ email, password });

    if (!user) {
      return res.json({ success: false, message: "No user found!" });
    } else if (!user.verified) {
      return res.json({ success: false, message: "User not verified" });
    }

    const token = generateToken({ email, role: user.role });
    setCookie(res, token);
    return res.json({ success: true, message: "Successful", role: "USER" });
  } catch (error) {
    return res.json({ success: false, message: "Server error" });
  }
};

export const signup = async (req, res) => {
  try {
    const { name, age, email, username, password } = req.body;

    if (!name || !age || !email || !username || !password) {
      return res.json({ success: false, message: "All fields are required!" });
    }

    const userExist = await User.findOne({ email });

    if (userExist) {
      return res.json({ success: false, message: "User already exists" });
    }

    const user = await User.create({
      name,
      age,
      username,
      email,
      password,
    });

    if (!user) {
      return res.json({
        success: false,
        message: "User not created",
      });
    }

    return res.json({
      success: true,
      message: "User created successfully",
    });
  } catch (error) {
    return res.json({ success: false, message: "Server error" });
  }
};

const mockOTP = 1234;

export const verifyOTP = async (req, res) => {
  try {
    const { email, otp } = req.body;

    if (!otp || !email) {
      return res.json({ success: false, message: "Invalid request!" });
    }

    if (otp != mockOTP) {
      return res.json({ success: false, message: "Wrong OTP!" });
    }

    const user = await User.findOneAndUpdate(
      { email },
      { verified: true },
      { new: true }
    );

    if (!user) {
      return res.json({ success: false, message: "User not found" });
    }

    const token = generateToken({ email, role: user.role });
    setCookie(res, token);
    return res.json({ success: true, message: "Verified successfully" });
  } catch (error) {
    return res.json({ success: false, message: "Server error" });
  }
};

export const logout = (req, res) => {
  try {
    res.clearCookie("token");
    return res.json({ success: true, message: "Logged out successfully" });
  } catch (error) {
    return res.json({ success: false, message: "Server error" });
  }
};
