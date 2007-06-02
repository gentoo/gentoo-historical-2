# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-games/gnome-games-2.16.3.ebuild,v 1.11 2007/06/02 02:52:24 ranger Exp $

# make sure games is inherited first so that the gnome2
# functions will be called if they are not overridden
inherit games eutils gnome2 autotools

DESCRIPTION="Collection of games for the GNOME desktop"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 FDL-1.1"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ppc64 ~sh sparc x86"
IUSE="artworkextra guile" #avahi disabled upstream due to crashes

RDEPEND=">=gnome-base/gconf-2
	>=gnome-base/libgnomeui-2
	>=gnome-base/libgnome-2
	>=x11-libs/gtk+-2.8
	>=gnome-base/librsvg-2
	>=gnome-base/libglade-2
	>=dev-libs/glib-2.6.3
	>=gnome-base/gnome-vfs-2
	>=x11-libs/cairo-1
	guile? ( >=dev-scheme/guile-1.6.5 )
	artworkextra? ( gnome-extra/gnome-games-extra-data )
	>=gnome-base/gnome-common-2.12.0"
#	avahi? ( net-dns/avahi )
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.35
	>=sys-devel/gettext-0.10.40
	>=app-text/scrollkeeper-0.3.8"

# Others are installed below; multiples in this package.
DOCS="HACKING MAINTAINERS"

pkg_setup() {
	# create the games user / group
	games_pkg_setup

	G2CONF="--with-scores-group=${GAMES_GROUP} \
		$(use_enable guile)"
#		$(use_enable avahi)"

	if use guile; then
		if has_version =dev-scheme/guile-1.8*; then
			local flags="deprecated regex"
			built_with_use dev-scheme/guile ${flags} || die "guile must be built with \"${flags}\" use flags"
		fi
	fi
}

src_unpack() {
	gnome2_src_unpack

	# Resolve symbols at execution time in setgid binaries
	epatch ${FILESDIR}/${PN}-2.14.0-no_lazy_bindings.patch

	# Implement --enable-guile switch
	epatch ${FILESDIR}/${PN}-2.13.1-guile_switch.patch

	AT_M4DIR="./m4" eautoreconf
}

src_install() {
	gnome2_src_install

	# Documentation install for each of the games
	for game in \
	$(find . -maxdepth 1 -type d ! -name po ! -name libgames-support); do
		docinto ${game}
		for doc in AUTHORS ChangeLog NEWS README TODO; do
			[ -s ${game}/${doc} ] && dodoc ${game}/${doc}
		done
	done
}

pkg_preinst() {
	# Avoid overwriting previous .scores files
	local basefile
	for scorefile in ${D}/var/lib/games/*.scores; do
		basefile=$(basename $scorefile)
		if [ -s "${ROOT}/var/lib/games/${basefile}" ]; then
			cp "${ROOT}/var/lib/games/${basefile}" \
			"${D}/var/lib/games/${basefile}"
		fi
	done
}
