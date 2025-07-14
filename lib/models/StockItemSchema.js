const mongoose = require('mongoose');

const StockItemSchema = new mongoose.Schema({
  name: { type: String, required: true },
  description: String,
  imagePath: String,
  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('StockItem', StockItemSchema);
