# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/raptor/raptor-1.4.18.ebuild,v 1.5 2009/05/12 08:47:31 ssuominen Exp $

EAPI=2
inherit eutils

DESCRIPTION="The RDF Parser Toolkit"
HOMEPAGE="http://librdf.org/raptor"
SRC_URI="http://download.librdf.org/source/${P}.tar.gz"

LICENSE="LGPL-2.1 Apache-2.0"
SLOT="0"
KEYWORDS="amd64 hppa ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="curl unicode xml"

RDEPEND="unicode? ( >=dev-libs/glib-2 )
	xml? ( >=dev-libs/libxml2-2.6.8 )
	!xml? ( dev-libs/expat )
	curl? ( net-misc/curl )
	dev-libs/libxslt"
DEPEND="${RDEPEND}
	sys-devel/flex
	dev-util/pkgconfig"

src_prepare() {
	epunt_cxx
}

src_configure() {
	local myconf

	if use xml; then
		myconf="${myconf} --with-xml-parser=libxml"
	else
		myconf="${myconf} --with-xml-parser=expat"
	fi

	if use curl; then
		myconf="${myconf} --with-www=curl"
	elif use xml; then
		myconf="${myconf} --with-www=xml"
	else
		myconf="${myconf} --with-www=none"
	fi

	econf \
		$(use_enable unicode nfc-check) \
		${myconf}
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS NOTICE README
	dohtml NEWS.html README.html RELEASE.html
}
