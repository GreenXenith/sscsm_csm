# SSCSM
### Server-Sent Client-Side Mods (Receiver)

This is the receiving end to the [SSCSM mod](https://github.com/GreenXenith/sscsm_ssm). It allows servers to send client-side mods to the client in order to offload work.  

## Usage

### Download
#### ZIP Archive
`Clone or download` -> `Download ZIP`  
Download to desired folder, and extract contents into `/minetestdir/clientmods/`.  

#### GIT
```
cd /path/to/minetest/clientmods/
git clone https://github.com/GreenXenith/sscsm_csm.git
```

### Enable
Make sure `enable_client_modding` is `true` in your `minetest.conf`.  
Add `load_mod_sscsm = true` to your client `mods.conf`.
