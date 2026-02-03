import Cart from "../model/cart.model.js";
import User from "../model/user.model.js";
import Book from "../model/book.model.js";

export const addToCart = async (req, res) => {
  const bookId = req.params.id;

  const email = req.user.email;
  const user = await User.findOne({ email });
  console.log("User: ", user);

  const bookExists = await Cart.findOne({ email: user._id, book: bookId });

  if (bookExists) {
    return res.json({ message: "Already added!" });
  }

  const book = await Book.findById(bookId);

  if (!book) {
    return res.status(404).json({ message: "Book not found" });
  }

  const response = await Cart.create({
    user: user._id,
    book: bookId,
  });

  return res.json(response);
};

export const updateCartQuantity = async (req, res) => {
  const { quantity } = req.body;
  const cartId = req.params.id;

  if (quantity < 1) {
    return res.status(400).json({ message: "Quantity must be at least 1" });
  }

  const email = req.user.email;
  const user = await User.findOne({ email });

  console.log("UserId: ", user);
  console.log("CartId: ", cartId);

  const cartItem = await Cart.findOneAndUpdate(
    { _id: cartId, user: user._id },
    { quantity },
    { new: true }
  );
  console.log("Cartitem: ", cartItem);
  if (!cartItem) {
    return res.status(404).json({ message: "Cart item not found" });
  }

  return res.json(cartItem);
};

export const removeFromCart = async (req, res) => {
  const { cartId } = req.params;

  const email = req.user.email;
  const user = await User.findOne({ email });

  const cartItem = await Cart.findOneAndDelete({
    _id: cartId,
    user: user._id,
  });

  if (!cartItem) {
    return res.status(404).json({ message: "Cart item not found" });
  }

  return res.json({ message: "Item removed from cart" });
};
