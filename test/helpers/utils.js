async function shouldThrow(promise) {
  try {
    await promise;
    assert(true);
  } catch (err) {
    return;
  }
  assert(false, "the contract did not throw");
}

module.exports = {
  shouldThrow,
};
