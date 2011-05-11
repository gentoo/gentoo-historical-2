# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-backup/dar/dar-2.3.11.ebuild,v 1.1 2011/05/11 16:26:43 matsuu Exp $

EAPI="3"
inherit confutils flag-o-matic

DESCRIPTION="A full featured backup tool, aimed for disks (floppy,CDR(W),DVDR(W),zip,jazz etc.)"
HOMEPAGE="http://dar.linux.free.fr/"
SRC_URI="mirror://sourceforge/dar/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="acl dar32 dar64 doc nls ssl static static-libs"

RDEPEND=">=sys-libs/zlib-1.2.3
	>=app-arch/bzip2-1.0.2
	acl? (
		static? ( sys-apps/attr[static-libs] )
		!static? ( sys-apps/attr )
	)
	nls? ( virtual/libintl )
	ssl? ( dev-libs/openssl )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	doc? ( app-doc/doxygen )"

pkg_setup() {
	confutils_use_conflict dar32 dar64
}

src_configure() {
	local myconf="--disable-upx"

	# Bug 103741
	filter-flags -fomit-frame-pointer

	use acl || myconf="${myconf} --disable-ea-support"
	use dar32 && myconf="${myconf} --enable-mode=32"
	use dar64 && myconf="${myconf} --enable-mode=64"
	use doc || myconf="${myconf} --disable-build-html"
	# use examples && myconf="${myconf} --enable-examples"
	use nls || myconf="${myconf} --disable-nls"
	use ssl || myconf="${myconf} --disable-libcrypto-linking"
	if ! use static ; then
		myconf="${myconf} --disable-dar-static"
		if ! use static-libs ; then
			myconf="${myconf} --disable-static"
		fi
	fi

	econf ${myconf} || die
}

src_install() {
	emake DESTDIR="${D}" pkgdatadir=/usr/share/doc/${PF}/html install || die

	use static-libs || find "${ED}" -name '*.la' -o -name '*.a' -exec rm {} +

	dodoc AUTHORS ChangeLog NEWS README THANKS TODO || die
}
