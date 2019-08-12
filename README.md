# mkr-authority
Custom authority for allowing MKR to govern MKR.

Intentionally simple. Once set as the MKR token's authority, if the MKR token's `owner` field is subsequently set to
zero, the following properties obtain:
* MKR's `stop()` method can no longer be called
* MKR's `setOwner()` method can no longer be called
* only authorized users (according to the MkrAuthority's `ward`s) can call MKR's `mint()` function

K proofs of the contract's functionality can be found in: https://github.com/makerdao/k-mkr-authority/
