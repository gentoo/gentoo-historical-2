# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Karl Trygve Kalleberg <karltk@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-office/abiword/abiword-0.9.6.1-r1.ebuild,v 1.2 2002/02/10 18:23:36 verwilst Exp $

S=${WORKDIR}/${P}/abi
DESCRIPTION="Text processor"
SRC_URI="http://download.sourceforge.net/abiword/abiword-${PV}.tar.gz"
HOMEPAGE="http://www.abisource.com"
SLOT="0"
DEPEND="virtual/glibc
	>=sys-devel/gcc-2.95.2
	=media-libs/freetype-1.3.1-r3
	>=media-libs/libpng-1.0.7
	>=media-libs/jpeg-6b-r2
	>=x11-libs/gtk+-1.2.10-r4
	gnome? ( >=gnome-base/gnome-libs-1.4.1.2-r1
		>=dev-libs/libunicode-0.4-r1
		>=gnome-base/bonobo-1.0.9-r1
		>=gnome-extra/gal-0.13-r1 )
	perl?  ( >=sys-devel/perl-5.6 )
	spell? ( >=app-text/pspell-0.11.2 )
	xml2?  ( >=dev-libs/libxml2-2.4.10 )
	virtual/x11"


src_unpack() {

	unpack ${A}

	# Fix perl stuff install outside sandbox
	cd ${S}/src/bindings/perl
	patch <${FILESDIR}/gentoo-perl.diff || die
	cd ${S}
}

src_compile() {

	local myconf
	if [ "`use gnome`" ] ; then
		myconf="${myconf} --with-gnome --enable-gnome"
		export ABI_OPT_BONOBO=1
	fi

	if [ "`use perl`" ] ; then
		myconf="${myconf} --enable-scripting"
	fi
	
	if [ "`use spell`" ] ; then
		myconf="${myconf} --with-pspell"
	fi

	if [ "`use xml2`" ] ; then
		myconf="${myconf} --with-libxml2"
	fi

	./autogen.sh
	
	echo
	echo "*************************************************"
	echo "* Ignore above ERROR as it does not cause build *"
	echo "* to fail.                                      *"
	echo "*************************************************"
	echo

	CFLAGS="$CFLAGS `gdk-pixbuf-config --cflags`"

	./configure --host=${CHOST} \
		--prefix=/usr \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		--sysconfdir=/etc \
		--localstatedir=/var/lib \
		--with-libjpeg \
		--enable-extra-optimization \
		${myconf} || die

	# Doesn't work with -j 4 (hallski)
	make UNIX_CAN_BUILD_STATIC=0 \
		OPTIMIZER="${CFLAGS}" || die
}

src_install() {

	dodir /usr/{bin,lib}

	make prefix=${D}/usr \
		mandir=${D}/usr/share/man \
		infodir=${D}/usr/share/info \
		sysconfdir=${D}/etc \
		localstatedir=${D}/var/lib \
		install || die
	
	cp ${D}/usr/bin/AbiWord ${WORKDIR}/AbiWord.orig
	sed -e "s:${D}::" ${WORKDIR}/AbiWord.orig > ${D}/usr/bin/AbiWord
	
	rm -f ${D}/usr/bin/abiword
	dosym /usr/bin/AbiWord /usr/bin/abiword

	dodoc BUILD COPYING *.txt, *.TXT

	# Install icon and .desktop for menu entry
	if [ "`use gnome`" ] ; then
		insinto /usr/share/pixmaps
		newins ${WORKDIR}/${P}/abidistfiles/icons/abiword_48.png AbiWord.png
		insinto /usr/share/gnome/apps/Applications
		doins ${FILESDIR}/AbiWord.desktop
	fi
}

pkg_postinst() {

	# Appending installation info
	cat /usr/lib/perl5/5.6.0/i386-linux/perllocal.pod.new \
		>> /usr/lib/perl5/5.6.0/i386-linux/perllocal.pod
	rm -rf /usr/lib/perl5/5.6.0/i386-linux/perllocal.pod.new
}
