# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/glame/glame-0.6.3.ebuild,v 1.10 2004/06/25 00:01:00 agriffis Exp $

IUSE="nls gnome"

DESCRIPTION="Glame is an audio file editing utility"
HOMEPAGE="http://glame.sourceforge.net/"
SRC_URI="mirror://sourceforge/glame/${P}.tar.gz"
RESTRICT="nomirror"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

RDEPEND=">=dev-util/guile-1.4-r3
	dev-libs/libxml2
	>=media-sound/esound-0.2
	media-libs/audiofile
	gnome? ( <gnome-base/libglade-2 gnome-base/gnome-libs )"

DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${A}

	# fix NLS problem (bug #7587)
	if ! use nls
	then
		cd ${S}/src/gui
		mv swapfilegui.c swapfilegui.c.bad
		sed -e "s:#include <libintl.h>::" swapfilegui.c.bad > swapfilegui.c
	fi
}

src_compile() {
	if use gnome
	then
		# Use a valid icon for the GNOME menu entry
		cp src/gui/glame.desktop src/gui/glame.desktop.old
		sed -e 's:glame.png:glame-logo.jpg:' \
			src/gui/glame.desktop.old > src/gui/glame.desktop
		rm src/gui/glame.desktop.old
	fi

	local myconf=""

	use nls	&& myconf="--enable-nls" \
		|| myconf="--disable-nls"
	use gnome || myconf="$myconf --disable-gui"

	# needed to not break configure
	unset CFLAGS
	econf --with-included-gettext ${myconf} || die "Configuration failed"

	emake || die "Compilation failed"
}

src_install () {
	einstall || die "Installation failed"

	if use gnome
	then
		dodir /usr/share/pixmaps
		dosym ../glame/pixmaps/glame-logo.jpg \
		      /usr/share/pixmaps/glame-logo.jpg
	fi

	dodoc ABOUT-NLS AUTHORS BUGS COPYING CREDITS ChangeLog MAINTAINERS \
		NEWS README TODO
}

