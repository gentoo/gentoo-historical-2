# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-pda/synce-libsynce/synce-libsynce-0.15.ebuild,v 1.2 2010/07/28 09:51:22 ssuominen Exp $

EAPI=2

DESCRIPTION="SynCE - common library"
HOMEPAGE="http://sourceforge.net/projects/synce/"
SRC_URI="mirror://sourceforge/synce/libsynce-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="dbus static-libs"

RDEPEND=">=dev-libs/check-0.9
	dbus? ( >=dev-libs/dbus-glib-0.60 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S=${WORKDIR}/libsynce-${PV}

src_configure() {
	econf \
		--disable-dependency-tracking \
		$(use_enable static-libs static) \
		--enable-dccm-file-support \
		$(use_enable dbus odccm-support) \
		--disable-hal-support
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc ChangeLog README TODO
	find "${D}" -name '*.la' -delete
}
