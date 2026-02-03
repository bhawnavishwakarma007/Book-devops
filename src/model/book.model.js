import mongoose from "mongoose";

const bookSchema = new mongoose.Schema(
  {
    qty: {
      type: Number,
      default: 1,
      min: [0, "Quantity cannot be negative"],
    },
    bookname: {
      type: String,
      trim: true,
      required: [true, "Book name is required"],
      index: true,
    },
    authorname: {
      type: String,
      trim: true,
      required: [true, "Author name is required"],
      index: true,
    },
    price: {
      type: Number,
      required: [true, "Price is required"],
      min: [0, "Price cannot be negative"],
    },
    description: {
      type: String,
      required: [true, "Description is required"],
      trim: true,
    },
  },
  {
    timestamps: true,
  }
);

const Book = mongoose.model("Book", bookSchema);

export default Book;
