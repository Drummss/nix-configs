1M ef02 BIOS boot
500M ef00 ESP
4G 8200 Swap
100% 8300/bf01 Linux/ZFS

export DISK=/dev/sd$N
export HOSTNAME=singularity

mkfs.fat -F32 -n ESP ${DISK}2
mkswap -L Swap ${DISK}3

zpool create \
        -O compress=zstd \
        -O checksum=edonr \
        -O dedup=off \
        -O recordsize=8k \
        -O mountpoint=none \
        -O encryption=on \
        -O keylocation=prompt \
        -O keyformat=passphrase \
        -o failmode=continue \
        -o autoexpand=on \
        -o ashift=12 \
        -o comment="Singularity Root ZFS" \
        zroot /dev/disk/by-id/[!ROOT_PARTITION!]
zfs create -o mountpoint=legacy zroot/nixos
zfs create -o mountpoint=legacy -o atime=off zroot/nixos/store

zpool create \
        -O compress=zstd-5 \
        -O checksum=edonr \
        -O dedup=off \
        -O recordsize=64k \
        -O mountpoint=none \
        -O encryption=on \
        -O keylocation=prompt \
        -O keyformat=passphrase \
        -o failmode=continue \
        -o autoexpand=on \
        -o ashift=12 \
        -o comment="Singularity Storage ZFS" \
        zstorage mirror /dev/disk/by-id/[!MIRROR_PARTITION,MIRROR_PARTITION!] cache /dev/disk/by-id/[!CACHE_PARTITION!]
