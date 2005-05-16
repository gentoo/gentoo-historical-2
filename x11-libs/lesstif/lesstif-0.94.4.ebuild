# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/lesstif/lesstif-0.94.4.ebuild,v 1.4 2005/05/16 14:39:53 lanius Exp $

inherit libtool flag-o-matic multilib

DESCRIPTION="An OSF/Motif(R) clone"
HOMEPAGE="http://www.lesstif.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="2.1"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~ppc-macos ~sparc ~x86 ~ia64"
IUSE="static"

RDEPEND="virtual/libc
	virtual/x11
	>=x11-libs/motif-config-0.9"

DEPEND="dev-lang/perl
	${RDEPEND}
	>=sys-devel/libtool-1.5.10"

PROVIDE="virtual/motif"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/CAN-2005-0605.patch
}

src_compile() {
	use ppc-macos || libtoolize --force --copy

	if use ppc-macos; then
		append-ldflags -L/usr/X11R6/lib -lX11 -lXt
	fi

	econf \
	  $(use_enable static) \
	  --enable-production \
	  --enable-verbose=no \
	  --with-x || die "./configure failed"

	emake CFLAGS="${CFLAGS}" || die
}

src_install() {
	make DESTDIR=${D} install || die "make install"


	einfo "Fixing binaries"
	dodir /usr/$(get_libdir)/lesstif-2.1
	for file in `ls ${D}/usr/bin`
	do
		mv ${D}/usr/bin/${file} ${D}/usr/$(get_libdir)/lesstif-2.1/${file}
	done

	einfo "Fixing libraries"
	mv ${D}/usr/lib/* ${D}/usr/$(get_libdir)/lesstif-2.1/

	einfo "Fixing includes"
	dodir /usr/include/lesstif-2.1/
	mv ${D}/usr/include/* ${D}/usr/include/lesstif-2.1

	einfo "Fixing man pages"
	mans="1 3 5"
	for man in $mans; do
		dodir /usr/share/man/man${man}
		for file in `ls ${D}/usr/share/man/man${man}`
		do
			file=${file/.${man}/}
			mv ${D}/usr/share/man/man$man/${file}.${man} ${D}/usr/share/man/man${man}/${file}-lesstif-2.1.${man}
		done
	done


	einfo "Fixing docs"
	dodir /usr/share/doc/
	mv ${D}/usr/LessTif ${D}/usr/share/doc/${P}
	rm -fR ${D}/usr/$(get_libdir)/LessTif

	# cleanup
	rm -f ${D}/usr/$(get_libdir)/lesstif-2.1/mxmkmf
	rm -fR ${D}/usr/share/aclocal/
	rm -fR ${D}/usr/$(get_libdir)/lesstif-2.1/LessTif/
	rm -fR ${D}/usr/$(get_libdir)/lesstif-2.1/X11/
	rm -fR ${D}/usr/$(get_libdir)/X11/
	rm -f ${D}/usr/$(get_libdir)/lesstif-2.1/motif-config

	# profile stuff
	dodir /etc/env.d
	echo "LDPATH=/usr/lib/lesstif-2.1" > ${D}/etc/env.d/15lesstif-2.1
	dodir /usr/$(get_libdir)/motif
	echo "PROFILE=lesstif-2.1" > ${D}/usr/$(get_libdir)/motif/lesstif-2.1
}

pkg_postinst() {
	motif-config -s
}

pkg_postrm() {
	motif-config -s
}
