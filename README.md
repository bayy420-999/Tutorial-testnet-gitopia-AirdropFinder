# Tutorial testnet Gitopia Airdropfinder

<p style="font-size:14px" align="right">
<a href="https://t.me/airdropfind" target="_blank">Join Telegram Airdrop Finder<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/></a>
</p>

<p align="center">
  <img height="auto" width="auto" src="https://raw.githubusercontent.com/bayy420-999/airdropfind/main/NavIcon.png">
</p>


## Referensi

[Dokumen resmi Gitopia](https://docs.gitopia.com/)

[Discord Gitopia](https://discord.gg/32hSE7H83x)

## Persyaratan

### Persyaratan perangkat keras

| Komponen | Spesifikasi minimal |
|----------|---------------------|
|CPU|4 Cores|
|RAM|32 GB DDR4 RAM|
|Penyimpanan|1 TB HDD|
|Koneksi|10Mbit/s port|

| Komponen | Spesifikasi rekomendasi |
|----------|---------------------|
|CPU|32 Cores|
|RAM|32 GB DDR4 RAM|
|Penyimpanan|2 x 1 TB NVMe SSD|
|Koneksi|1 Gbit/s port|

### Persyaratan perangkat lunak

| Komponen | Spesifikasi minimal |
|----------|---------------------|
|Sistem Operasi|Ubuntu 16.04|

| Komponen | Spesifikasi rekomendasi |
|----------|---------------------|
|Sistem Operasi|Ubuntu 18.04 atau lebih tinggi|

## Pemasangan

### Pasang dependesi

```console
apt-get install curl screen
```

### Buka terminal baru

```console
screen -Rd gitopia
```

### Pasang program gitopia

```console
curl https://raw.githubusercontent.com/bayy420-999/Tutorial-testnet-gitopia-AirdropFinder/main/run.sh | sudo bash
```

Lalu masukan nama node

Setelah program berjalan, tutup terminal dengan menekan <kbd>CTRL</kbd>+<kbd>a</kbd>+<kbd>d</kbd>

### Cek apakah node sudah jalan

```console
gitopiad status 2>&1 | jq .SyncInfo
```

Cek apakah `catching_up` berstatus `false`, jika masih `true` maka anda belum dapat memulai langkah berikutnya

## Jalankan validator

### Buat dompet baru

```console
gitopiad keys add $GITOPIA_WALLET
```

Jangan lupa untuk menyimpan mnemonic


### Simpan informasi dompet

```console
GITOPIA_WALLET_ADDRESS=$(gitopiad keys show $GITOPIA_WALLET -a)
GITOPIA_VALOPER_ADDRESS=$(gitopiad keys show $GITOPIA_WALLET --bech val -a)
echo 'export GITOPIA_WALLET_ADDRESS='${GITOPIA_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export GITOPIA_VALOPER_ADDRESS='${GITOPIA_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```

Masukan password yang tadi dibuat

### Klaim faucet

Setelah dompet dibuat, masuk ke [website gitopia](https://gitopia.com/login) lalu login, pilih `Recover existing wallet` dan masukan mnemonic yang tadi lalu klaim faucet

### Buat validator

```console
gitopiad tx staking create-validator \
  --amount=1000000utlore \
  --pubkey=$(gitopiad tendermint show-validator) \
  --moniker="$GITOPIA_MONIKER" \
  --chain-id="$GITOPIA_CHAIN_ID" \
  --commission-rate="0.10" \
  --commission-max-rate="0.20" \
  --commission-max-change-rate="0.01" \
  --min-self-delegation="1000000" \
  --gas="auto" \
  --gas-prices="0.001utlore" \
  --from="$GITOPIA_WALLET"
```

## Perintah berguna

### Monitoring

* Cek informasi blok

  ```console
  gitopiad status 2>&1 | jq .SyncInfo
  ```

* Cek informasi node

  ```console
  gitopiad status 2>&1 | jq .NodeInfo
  ```
  
* Cek Node id

  ```console
  gitopiad tendermint show-node-id
  ```


### Pengoperasian validator

* Edit validator

  ```console
  gitopiad tx staking edit-validator
  --moniker="choose a moniker" \
  --website="https://gitopia.com" \
  --identity=6A0D65E29A4CBC8B \
  --details="Code Collaboration for Web3" \
  --chain-id=<chain_id> \
  --gas="auto" \
  --gas-prices="0.001utlore" \
  --from=<key_name> \
  --commission-rate="0.10"
  ```

* Bebaskan validator

  ```console
  gitopiad tx slashing unjail \
    --from="$GITOPIA_WALLET" \
    --chain-id="$GITOPIA_CHAIN_ID"
  ```

### Pengoperasian dompet

* Buat dompet baru

  ```console
  gitopiad keys add <NAMA_DOMPET>
  ```
* Melihat list dompet

  ```console
  gitopiad keys list
  ```

* Melihat alamat dompet

  ```console
  gitopiad keys show <NAMA_DOMPET> -a
  ```

* Melihat alamat valoper dompet

  ```console
  gitopiad keys show <NAMA_DOMPET> --bech val -a 
  ```

* Memulihkan dompet

  ```console
  gitopiad keys add <NAMA_DOMPET> --recover
  ```

* Hapus dompet 

  ```console
  gitopiad keys delete <NAMA_DOMPET>
  ```
  
* Melihat saldo dompet

  ```console
  gitopiad query bank balances <NAMA_DOMPET>
  ```

* Transfer saldo dompet

  ```console
  gitopiad tx bank send <ALAMAT_DOMPET_ANDA> <ALAMAT_PENERIMA> <JUMLAH_YANG_AKAN_DITRANSFER>
  ``` 

### Voting

```console
gitopiad tx gov vote 1 yes --from $GITOPIA_WALLET --chain-id=$GITOPIA_CHAIN_ID
```

### Stake, delegasi dan upah

* Delegasi stake

  ```console
  gitopiad tx staking delegate $GITOPIA_VALOPER_ADDRESS 10000000unibi --from=$GITOPIA_WALLET --chain-id=$GITOPIA_CHAIN_ID --gas=auto
  ```

* Mendelegasikan ulang dari validator ke validator lain

  ```console
  gitopiad tx staking redelegate $GITOPIA_VALOPER_ADDRESS <ALAMAT_DOMPET_TUJUAN> <JUMLAH> --from=$GITOPIA_WALLET --chain-id=$GITOPIA_CHAIN_ID --gas=auto
  ```
 
* Tarik semua upah

  ```console
  gitopiad tx distribution withdraw-all-rewards --from=$GITOPIA_WALLET --chain-id=$GITOPIA_CHAIN_ID --gas=
  ```

* Tarik upah dengan komisi

  ```console
  gitopiad tx distribution withdraw-rewards $GITOPIA_VALOPER_ADDRESS --from=$GITOPIA_WALLET --commission --chain-id=$GITOPIA_CHAIN_ID
  ```
## Troubleshoot

Nanti aja