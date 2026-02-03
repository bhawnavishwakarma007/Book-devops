import Book from "../model/book.model.js";

export const addBook = async (req, res) => {
  try {
    const { bookname, authorname, price, description } = req.body;

    if (!bookname || !authorname || !price || !description) {
      return res.json({ message: "Invalid data" });
    }

    const response = await Book.create({
      bookname,
      authorname,
      price,
      description,
    });

    return res.json(response);
  } catch (error) {
    return res.json({ message: "Server error", error: error.message });
  }
};

export const updateQty = async (req, res) => {
  try {
    const { qty } = req.body;
    const bookId = req.params.id;

    if (!bookId || qty == null || qty <= 0) {
      return res.json({ message: "Invalid input" });
    }

    const response = await Book.findOneAndUpdate(
      { _id: bookId },
      { $set: { qty } },
      { new: true }
    );

    if (!response) {
      return res.json({ message: "Book not found" });
    }

    return res.json({ message: "Successfully updated!", data: response });
  } catch (error) {
    return res.json({ message: "Server error", error: error.message });
  }
};

export const deleteBook = async (req, res) => {
  try {
    const bookId = req.params.id;

    if (!bookId) {
      return res.json({ message: "Invalid value" });
    }

    const response = await Book.deleteOne({ _id: bookId });

    if (response.deletedCount === 0) {
      return res.json({ message: "Book not found" });
    }

    return res.json({ message: "Book deleted successfully" });
  } catch (error) {
    return res.json({ message: "Server error", error: error.message });
  }
};

export const getBooks = async (req, res) => {
  try {
    const response = await Book.find({});
    return res.json(response);
  } catch (error) {
    return res.json({ message: "Server error", error: error.message });
  }
};

export const searchBook = async (req, res) => {
  try {
    const { bookname, authorname } = req.body;

    if (!bookname && !authorname) {
      return res.json({ message: "Provide bookname or authorname" });
    }

    const query = [];
    if (bookname) query.push({ bookname: { $regex: bookname, $options: "i" } });
    if (authorname)
      query.push({ authorname: { $regex: authorname, $options: "i" } });

    const response = await Book.find({ $or: query });

    return res.json(response);
  } catch (error) {
    return res.json({ message: "Server error", error: error.message });
  }
};
