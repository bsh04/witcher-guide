String? isRequired(String? value) {
  if (value == null || value == "") {
    return "Required";
  }
  return null;
}