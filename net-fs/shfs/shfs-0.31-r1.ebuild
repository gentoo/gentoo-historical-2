# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-fs/shfs/shfs-0.31-r1.ebuild,v 1.6 2003/11/23 23:44:45 seemant Exp $

IUSE="amd doc"

MY_P=${P}-1
S=${WORKDIR}/${MY_P}
DESCRIPTION="Secure Shell File System"
HOMEPAGE="http://shfs.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc amd64"

DEPEND="virtual/linux-sources
		net-misc/openssh
		amd? ( net-fs/am-utils )"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/shfs-gentoo-${PV}-makefile-root.diff
	use ppc && epatch ${FILESDIR}/shfs-gentoo-${PV}-ppc.diff
	use amd64 && epatch ${FILESDIR}/shfs-amd64-makefile.patch
}

src_compile() {
	emake || die
}

src_install() {
	# Install kernel module
	cd ${S}/shfs
	mv Makefile Makefile.old
	cat Makefile.old | grep -v depmod > Makefile
	einfo " Installing kernel module..."
	make MODULESDIR=${D}/lib/modules/${KV} install || die

	# Install binaries
	cd ${S}/shfsmount
	dobin shfsmount
	dobin shfsumount

	# Allows users to mount/umount
	einfo " Setting suid bit on /usr/bin executables..."
	fperms 4511 /usr/bin/shfsmount
	fperms 4511 /usr/bin/shfsumount

	# Performs symlink to support use of mount(8)
	dodir /sbin
	einfo " Adding /sbin/mount.shfs symlink..."
	dosym /usr/bin/shfsmount /sbin/mount.shfs

	# Install docs
	doman ${S}/docs/manpages/shfsmount.8 ${S}/docs/manpages/shfsumount.8
	use doc && dohtml -r ${S}/docs/html

	# Install automount support (if desired)
	if [ -n "`use amd`" ] ; then
		einfo " Installing am-utils config files..."
		insinto /etc/amd
		doins ${FILESDIR}/amd.conf
		doins ${FILESDIR}/amd.shfs
		exeinto /etc/amd
		doexe ${FILESDIR}/shfs.mount
		dosym /etc/amd/shfs.mount /etc/amd/shfs.unmount
	fi
}

pkg_postinst() {
	echo "running depmod...."
	depmod -aq || die

	echo " "
	einfo " Use either 'shfsmount' or 'mount -t shfs' to mount remote"
	einfo " filesystems to into your local filesystem.               "
	echo " "
	echo " "
	einfo " Note the following:                                      "
	einfo "                                                          "
	einfo "   1.  The shfs.o kernel module has to be loaded first    "
	einfo "       before you can start mounting filesystems.         "
	einfo "       Try: 'insmod shfs' as root.                        "
	einfo "                                                          "
	einfo "   2.  When mounting, you must enter the absolute path of "
	einfo "       the remote filesystem without any special chars,   "
	einfo "       such as tilde (~), for example.                    "
	echo " "
}
