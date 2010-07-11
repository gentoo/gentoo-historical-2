# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/389-dsgw/389-dsgw-1.1.5.ebuild,v 1.2 2010/07/11 16:47:49 lxnay Exp $

EAPI="2"

inherit autotools eutils

DESCRIPTION="389 Directory Server Gateway Web Application"
HOMEPAGE="http://port389.org/"
SRC_URI="http://directory.fedoraproject.org/sources/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug +adminserver"

DEPEND="adminserver? ( net-nds/389-admin )
	dev-libs/nspr
	dev-libs/nss
	dev-libs/cyrus-sasl
	dev-libs/mozldap
	dev-libs/icu
	dev-libs/389-adminutil"

RDEPEND="${DEPEND}
	dev-perl/perl-mozldap
	virtual/perl-CGI"

src_prepare() {
	# as per 389 documentation, when 64bit, export USE_64
	use amd64 && export USE_64=1
	eautoreconf
}

src_configure() {
	econf $(use_enable debug) \
		$(use_with adminserver) \
		--with-fhs || die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc README
}
