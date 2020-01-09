# mkr-authority
Custom authority for allowing MKR to govern MKR.

Intentionally simple. Once set as the MKR token's authority, if the MKR token's `owner` field is subsequently set to
zero, the following properties obtain:
* any user may call MKR's `burn` function
* only authorized users (according to the MkrAuthority's `ward`s) can call MKR's `mint()` function
* only the `root` user set in the authority can call other `auth`-protected functions of the MKR contract
* only the `root` user can modify the MkrAuthority's `ward`s or change the `root`

Though this contract could be used in different ways, it was designed in the context of an overall design for control 
of the MKR token via MKR governance as illustrated below.

```
<~~~ : points to source's authority
<=== : points to source's root or owner

-------    -------    ------------    --------------    -----
|Chief|<~~~|Pause|<===|PauseProxy|<===|MkrAuthority|<~~~|MKR|===>0
-------    -------    ------------    --------------    -----
```

Such a structure allows governance proposals voted in on the Chief to make arbtirary changes to the MKR token
and its permissions subject to a delay. (See DappHub contracts
[DSChief](https://github.com/dapphub/ds-chief) and [DSPause](https://github.com/dapphub/ds-pause)
for implementations of the voting contract and the delay contract, respectively.)

Note that the MkrAuthority allows for upgrading of the MKR token's `authority` or `owner` by the `root`.

K specifications of the contract's functionality can be found in: https://github.com/makerdao/k-mkr-authority/
