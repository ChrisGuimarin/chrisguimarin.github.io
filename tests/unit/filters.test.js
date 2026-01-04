/**
 * Unit tests for Eleventy filters
 * Run with: node tests/unit/filters.test.js
 */

const assert = require('assert');

// Test suite results
let passed = 0;
let failed = 0;

function test(name, fn) {
  try {
    fn();
    console.log(`✓ ${name}`);
    passed++;
  } catch (error) {
    console.error(`✗ ${name}`);
    console.error(`  ${error.message}`);
    failed++;
  }
}

// Mock the filter functions (copied from .eleventy.js)
const dateIso = (date) => {
  return date.toISOString();
};

const dateReadable = (date) => {
  return date.toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  });
};

const byCategory = (books, category) => {
  return books.filter(book => book.data.category === category);
};

// Tests for dateIso filter
console.log('\nTesting dateIso filter:');

test('should convert date to ISO string', () => {
  const date = new Date('2025-01-01T12:00:00Z');
  const result = dateIso(date);
  assert.strictEqual(result, '2025-01-01T12:00:00.000Z');
});

test('should handle different dates', () => {
  const date = new Date('2024-12-31T23:59:59Z');
  const result = dateIso(date);
  assert.strictEqual(result, '2024-12-31T23:59:59.000Z');
});

test('should handle current date', () => {
  const now = new Date();
  const result = dateIso(now);
  assert.strictEqual(typeof result, 'string');
  assert.ok(result.includes('T'));
  assert.ok(result.includes('Z'));
});

// Tests for dateReadable filter
console.log('\nTesting dateReadable filter:');

test('should format date as readable string', () => {
  const date = new Date('2025-01-01T12:00:00Z');
  const result = dateReadable(date);
  assert.ok(result.includes('2025'));
  assert.ok(result.includes('January') || result.includes('December'));
});

test('should include month name', () => {
  const date = new Date('2025-06-15T12:00:00Z');
  const result = dateReadable(date);
  assert.ok(result.includes('June') || result.includes('May'));
});

test('should include day number', () => {
  const date = new Date('2025-01-15T12:00:00Z');
  const result = dateReadable(date);
  assert.ok(result.includes('15') || result.includes('14') || result.includes('16'));
});

// Tests for byCategory filter
console.log('\nTesting byCategory filter:');

test('should filter books by category', () => {
  const books = [
    { data: { category: 'design', title: 'Book 1' } },
    { data: { category: 'leadership', title: 'Book 2' } },
    { data: { category: 'design', title: 'Book 3' } },
  ];
  const result = byCategory(books, 'design');
  assert.strictEqual(result.length, 2);
  assert.strictEqual(result[0].data.title, 'Book 1');
  assert.strictEqual(result[1].data.title, 'Book 3');
});

test('should return empty array if no matches', () => {
  const books = [
    { data: { category: 'design', title: 'Book 1' } },
    { data: { category: 'leadership', title: 'Book 2' } },
  ];
  const result = byCategory(books, 'nonexistent');
  assert.strictEqual(result.length, 0);
});

test('should handle empty book array', () => {
  const books = [];
  const result = byCategory(books, 'design');
  assert.strictEqual(result.length, 0);
});

test('should not modify original array', () => {
  const books = [
    { data: { category: 'design', title: 'Book 1' } },
    { data: { category: 'leadership', title: 'Book 2' } },
  ];
  const originalLength = books.length;
  byCategory(books, 'design');
  assert.strictEqual(books.length, originalLength);
});

// Summary
console.log('\n' + '='.repeat(50));
console.log(`Test Results: ${passed} passed, ${failed} failed`);
console.log('='.repeat(50));

process.exit(failed > 0 ? 1 : 0);
