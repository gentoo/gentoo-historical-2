# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/gqradio/gqradio-1.9.1.ebuild,v 1.4 2004/07/13 05:07:36 eradicator Exp $

IUSE="nls gnome"

DESCRIPTION="GQradio is an FM radio tuner app from the people who brought you GQrmpeg."
HOMEPAGE="http://gqmpeg.sourceforge.net/radio.html"
SRC_URI="mirror://sourceforge/gqmpeg/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~amd64"

DEPEND="=x11-libs/gtk+-2*
	>=media-libs/gdk-pixbuf-0.7.0
	>=media-libs/gdk-pixbuf-0.13.0"

RDEPEND="nls? ( sys-devel/gettext )"

src_compile() {
	local myconf
	use nls || myconf="--disable-nls"

	econf ${myconf} || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die

	dodoc ABOUT-NLS AUTHORS COPYING ChangeLog INSTALL NEWS README SKIN-SPECS TODO

	use gnome && ( \
		insinto /usr/share/gnome/apps/Multimedia
		doins ${FILESDIR}/gqmpeg.desktop
	)

}
