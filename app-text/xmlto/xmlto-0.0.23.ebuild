# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/xmlto/xmlto-0.0.23.ebuild,v 1.1 2009/12/21 03:49:38 vapier Exp $

EAPI="2"

inherit eutils autotools

DESCRIPTION="A bash script for converting XML and DocBook formatted documents to a variety of output formats"
HOMEPAGE="https://fedorahosted.org/xmlto/browser"
SRC_URI="https://fedorahosted.org/releases/x/m/xmlto/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd"
IUSE="latex"

RDEPEND="app-shells/bash
	|| ( sys-apps/which sys-freebsd/freebsd-ubin )
	dev-libs/libxslt
	>=app-text/docbook-xsl-stylesheets-1.62.0-r1
	~app-text/docbook-xml-dtd-4.2
	|| ( sys-apps/util-linux app-misc/getopt )
	|| ( >=sys-apps/coreutils-6.10-r1 sys-freebsd/freebsd-ubin )
	latex? ( >=app-text/passivetex-1.25
		>=dev-tex/xmltex-1.9-r2 )"
DEPEND="${RDEPEND}
	sys-devel/flex"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.0.22-format_fo_passivetex_check.patch \
		"${FILESDIR}"/${PN}-0.0.22-parallelmake.patch
	eautoreconf
}

src_configure() {
	has_version sys-apps/util-linux || export GETOPT="getopt-long"
	econf --prefix=/usr
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog FAQ NEWS README THANKS
	insinto /usr/share/doc/${PF}/xml
	doins doc/*.xml
}
