# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/ddccontrol/ddccontrol-0.1.3.ebuild,v 1.1 2005/08/03 19:56:29 robbat2 Exp $

inherit eutils

DESCRIPTION="DDCControl"
HOMEPAGE="http://ddccontrol.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="gtk doc nls"

RDEPEND="dev-libs/libxml2
	gtk? ( >=x11-libs/gtk+-2.4 )
	sys-apps/pciutils
	nls? ( sys-devel/gettext )
	>=app-misc/ddccontrol-db-20050329"
DEPEND="${RDEPEND}
	doc? ( >=app-text/docbook-xsl-stylesheets-1.65.1
		   >=dev-libs/libxslt-1.1.6
	       app-text/htmltidy )
	sys-kernel/linux-headers"

src_compile() {
	econf $(use_enable doc) \
		$(use_enable gtk gnome) \
		$(use_enable nls) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" htmldir="/usr/share/doc/${PF}/html" install || die
	dodoc AUTHORS ChangeLog NEWS README TODO
}
