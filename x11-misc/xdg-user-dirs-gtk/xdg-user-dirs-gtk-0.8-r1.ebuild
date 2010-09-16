# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xdg-user-dirs-gtk/xdg-user-dirs-gtk-0.8-r1.ebuild,v 1.2 2010/09/16 12:35:29 ssuominen Exp $

EAPI=2
inherit gnome.org

DESCRIPTION="xdg-user-dirs-gtk integrates xdg-user-dirs into the Gnome desktop and Gtk+ applications"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/xdg-user-dirs"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=x11-misc/xdg-user-dirs-0.13
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35
	dev-util/pkgconfig"

src_prepare() {
	sed -i \
		-e '/Encoding/d' \
		-e 's:OnlyShowIn=GNOME:NotShowIn=KDE:' \
		user-dirs-update-gtk.desktop.in || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README
}

pkg_postinst() {
	elog
	elog " This package tries to automatically use some sensible default "
	elog " directories for you documents, music, video and other stuff "
	elog
	elog " If you want to change those directories to your needs, see "
	elog " the settings in ~/.config/user-dir.dirs "
	elog
}
