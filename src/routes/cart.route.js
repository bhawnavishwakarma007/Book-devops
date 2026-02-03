import express from "express";
import {
  addToCart,
  updateCartQuantity,
  removeFromCart,
} from "../controllers/cart.controller.js";

const router = express.Router();

router.post("/add/:id", addToCart);
router.put("/update/:id", updateCartQuantity);
router.delete("/remove/:cartId", removeFromCart);

export default router;
