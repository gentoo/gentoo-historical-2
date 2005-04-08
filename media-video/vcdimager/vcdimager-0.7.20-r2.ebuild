# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/vcdimager/vcdimager-0.7.20-r2.ebuild,v 1.8 2005/04/08 17:35:40 hansmi Exp $

IUSE="xml2"

inherit eutils

DESCRIPTION="GNU VCDimager"
HOMEPAGE="http://www.vcdimager.org/"
SRC_URI="http://www.vcdimager.org/pub/vcdimager/vcdimager-0.7/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~ia64 ppc ~sparc x86 ~ppc64"

RDEPEND=">=dev-libs/libcdio-0.66
	xml2? ( >=dev-libs/libxml2-2.5.11 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/cdio.patch

	# Patch Makefile.in to install libvcd.
	epatch ${FILESDIR}/${P}-libvcd.patch
}

src_compile() {
	local myopts
	# We disable the xmltest because the configure script includes differently
	# than the actual XML-frontend C files.
	use xml2 \
		&& myopts="${myopts} --with-xml-prefix=/usr --disable-xmltest" \
		|| myopts="${myopts} --without-xml-frontend"

	econf ${myopts} || die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die

	dodoc AUTHORS BUGS ChangeLog FAQ HACKING NEWS README THANKS TODO
}

src_test() { :; }
