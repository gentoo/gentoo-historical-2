# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/sys-apps/shadow/shadow-20001016-r7.ebuild,v 1.2 2002/07/11 06:30:55 drobbins Exp $

DESCRIPTION="Utilities to deal with user accounts"
SRC_URI="ftp://ftp.pld.org.pl/software/shadow/old/${P}.tar.gz"
S=${WORKDIR}/${P}

DEPEND=">=sys-libs/pam-0.73 sys-devel/gettext"

RDEPEND=">=sys-libs/pam-0.73"

src_unpack() {
	unpack ${A}
	cd ${S}/src
	cp ${FILESDIR}/useradd.c ${S}/src
}

src_compile() {

	./configure \
	--disable-desrpc \
	--with-libcrypt \
	--with-libcrack \
	--with-libpam \
	--host=${CHOST} || die "bad configure"

	# Parallel make fails sometimes
	make LDFLAGS="" || die "compile problem"
}

src_install() {

	dodir /etc/default /etc/skel

	make \
	prefix=${D}/usr \
	exec_prefix=${D} \
	mandir=${D}/usr/share/man \
	install || die "install problem"

	# the manpage install is beyond my comprehension, and also broken.
	# just do it over.
	for q in man/*.[0-9]; do
		dir="${D}/usr/share/man/man${q##*.}"
		mkdir -p $dir
		cp $q $dir
	done


	mv ${D}/lib ${D}/usr
	dosed -e "s:/lib:/usr/lib:" -e "s: libshadow.so':':" /usr/lib/libshadow.la
	dosym /usr/sbin/useradd /usr/sbin/adduser
	dosym /usr/sbin/vipw /usr/sbin/vigr

	insinto /etc
	# Using a securetty with devfs device names added
	# (compat names kept for non-devfs compatibility)
	insopts -m0600 ; doins ${FILESDIR}/securetty
	insopts -m0600 ; doins ${S}/etc/login.access
	insopts -m0644 ; doins ${S}/etc/limits
	insopts -m0644 ; doins ${FILESDIR}/login.defs

	insinto /etc/pam.d ; insopts -m0644
	doins ${FILESDIR}/shadow
	newins ${FILESDIR}/shadow groupadd
	newins ${FILESDIR}/shadow useradd

	if [ -z "`use bootcd`" ]
	then
		cd ${S}/doc
		dodoc ANNOUNCE INSTALL LICENSE README WISHLIST
		docinto txt
		dodoc HOWTO LSM README.* *.txt
	else
		rm -rf ${D}/usr/share ${D}/usr/lib/lib*.{a,la}
	fi
}
