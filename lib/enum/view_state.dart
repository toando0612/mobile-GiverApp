enum ViewState {
  Idle, // When nothing is happening or just initialized
  Busy, // Typically shows a loading indicator of some sorts
  DataFetched, // Indicates that there's data available on the view
  NoDataAvailable, // Indicates that data was fetched successfully but nothing is available
  Error, // Indicates there's an error on the view
  Success, // Successful action occurred
  WrongQrFormat,
  InvalidCoupon,
  Confirmation,
  CouponDataReceived,
  WaitingForInput,
  EditUsername,
  EditPhone,
  EditImageUrl,
  EditLocation,
  EditCategory,
  FoodMerchant,
  ClothingMerchant,
  AccessoriesMerchant // The starting state that a form view is in
}