# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libungif/libungif-4.1.0.1b.ebuild,v 1.4 2003/09/22 01:35:12 avenj Exp $

inherit libtool

IUSE="X gif"

REAL_P=${P/.1b/b1}

S=${WORKDIR}/${REAL_P}
DESCRIPTION="A library for reading and writing gif images without LZW compression"
HOMEPAGE="http://prtr-13.ucsc.edu/~badger/software/libungif/index.shtml"
SRC_URI="mirror://gentoo/${REAL_P}.tar.bz2"

DEPEND="X? ( virtual/x11 )"

SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 ppc sparc alpha hppa amd64 ia64"

src_unpack() {
	unpack ${A}
	cd ${S}
	patch -p1 <${FILESDIR}/libungif-CVS.patch
	patch -p1 <${FILESDIR}/libungif-4.1.0-stdarg.patch
}

src_compile() {
	local myconf
	use X \
		&& myconf="--with-x" \
		|| myconf="--without-x"
	use alpha \
		&& myconf="${myconf} --host=alpha-unknown-linux-gnu"

	elibtoolize || die

	econf ${myconf} || die
	emake || die
}

src_install() {

	make \
		prefix=${D}/usr \
		install || die

	use gif && rm -rf ${D}/usr/bin

	dodoc AUTHORS BUGS COPYING ChangeLog NEWS ONEWS
	dodoc UNCOMPRESSED_GIF README TODO
	dodoc doc/*.txt
	dohtml -r doc
}

pkg_postinst() {

	use gif 2>/dev/null && (
		einfo "You had the gif USE flag set, so it is assumed that you want"
		einfo "the binary from giflib instead.  Please make sure you have"
		einfo "giflib emerged.  Otherwise, unset the gif flag and remerge this"
	) || (
		einfo "You did not have the gif USE flag, so your gif binary is being"
		einfo "provided by this package.  If you would rather use the binary"
		einfo "from giflib, please set the gif USE flag, and re-emerge both"
		einfo "this and giflib"
	)
}
