# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/abiword/abiword-2.8.6.ebuild,v 1.3 2010/07/06 14:18:30 jer Exp $

EAPI="3"

inherit alternatives gnome2 versionator

MY_MAJORV=$(get_version_component_range 1-2)

DESCRIPTION="Fully featured yet light and fast cross platform word processor"
HOMEPAGE="http://www.abisource.com/"
SRC_URI="http://www.abisource.com/downloads/${PN}/${PV}/source/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="collab cups gnome grammar latex libgda math ots openxml plugins readline spell wordperfect wmf thesaurus" # svg

# libgsf raised to make sure it provides gio backend (ebuild)
# not enabling telepathy backend for collab, it depends on libempathy-gtk which
# has be removed from empathy-2.30 already
RDEPEND="
	>=app-text/wv-1.2
	>=dev-libs/fribidi-0.10.4
	>=dev-libs/glib-2.16
	>=gnome-base/librsvg-2.16
	>=gnome-extra/libgsf-1.14.15
	>=media-libs/libpng-1.2
	media-libs/jpeg:0
	>=x11-libs/cairo-1.8[X]
	>=x11-libs/gtk+-2.14[cups?]
	gnome? (
		>=gnome-extra/gucharmap-2
		>=x11-libs/goffice-0.8:0.8 )
	plugins? (
		collab? (
			dev-cpp/asio
			>=dev-libs/boost-1.33.1
			>=dev-libs/libxml2-2.4
			>=net-libs/loudmouth-1
			net-libs/libsoup:2.4
			net-libs/gnutls )
		grammar? ( >=dev-libs/link-grammar-4.2.1 )
		latex? ( dev-libs/libxslt )
		libgda? (
			=gnome-extra/libgda-1*
			=gnome-extra/libgnomedb-1* )
		math? ( >=x11-libs/gtkmathview-0.7.5 )
		openxml? ( dev-libs/boost )
		ots? ( >=app-text/ots-0.5 )
		readline? ( sys-libs/readline )
		thesaurus? ( >=app-text/aiksaurus-1.2[gtk] )
		wordperfect? (
			>=app-text/libwpd-0.8
			>=media-libs/libwpg-0.1 )
		wmf? ( >=media-libs/libwmf-0.2.8 )
	)
	spell? ( >=app-text/enchant-1.2 )
	!<app-office/abiword-plugins-2.8"
#		svg? ( >=gnome-base/librsvg-2 )

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9"

pkg_setup() {
	# do not enable gnome-vfs
	G2CONF="${G2CONF}
		--enable-shave
		--disable-static
		--disable-maintainer-mode
		--disable-default-plugins
		--disable-builtin-plugins
		--disable-collab-backend-telepathy
		--enable-clipart
		--enable-statusbar
		--enable-templates
		--with-gio
		--without-gnomevfs
		$(use_with gnome goffice)
		$(use_enable cups print)
		$(use_enable collab collab-backend-xmpp)
		$(use_enable collab collab-backend-tcp)
		$(use_enable collab collab-backend-service)
		$(use_enable spell)"
}

src_configure() {
	local plugins=""

	if use plugins; then
		# Plugins depending on libgsf
		plugins="t602 docbook clarisworks wml kword hancom openwriter pdf
			loadbindings mswrite garble pdb applix opendocument sdw xslfo"

		# Plugins not depending on anything
		plugins="${plugins} gimp bmp freetranslation iscii s5 babelfish opml eml
			wikipedia gdict passepartout google presentation urldict hrtext mif"

		# inter7eps: eps.h
		# libtidy: gsf + tidy.h
		# paint: windows only ?
		use collab && plugins="${plugins} collab"
		use gnome && plugins="${plugins} goffice"
		use latex && plugins="${plugins} latex"
		use libgda && plugins="${plugins} gda"
		use math && plugins="${plugins} mathview"
		use openxml && plugins="${plugins} openxml"
		use ots && plugins="${plugins} ots"
		# psion: >=psiconv-0.9.4
		use readline && plugins="${plugins} command"
		# plugin doesn't build
		#use svg && plugins="${plugins} rsvg"
		use thesaurus && plugins="${plugins} aiksaurus"
		use wmf && plugins="${plugins} wmf"
		# wordperfect: >=wpd-0.8 >=wps-0.1
		use wordperfect && plugins="${plugins} wpg"
	fi

	gnome2_src_configure --enable-plugins="$(echo ${plugins})"
}

src_prepare() {
	gnome2_src_prepare

	# install icon to pixmaps (bug #220097)
	sed 's:icondir= $(datadir)/icons:icondir = $(datadir)/pixmaps:' \
		-i Makefile.am Makefile.in || die "sed 1 failed"
	# readme.txt will be installed using dodoc
	sed '/readme\.txt\|abw/d' \
		-i user/wp/Makefile.am user/wp/Makefile.in || die "sed 2 failed"
}

src_install() {
	gnome2_src_install

	sed "s:Exec=abiword:Exec=abiword-${MY_MAJORV}:" \
		-i "${D}"/usr/share/applications/abiword.desktop || die "sed 3 failed"

	mv "${D}/usr/bin/abiword" "${D}/usr/bin/AbiWord-${MY_MAJORV}"
	dosym AbiWord-${MY_MAJORV} /usr/bin/abiword-${MY_MAJORV}

	dodoc AUTHORS user/wp/readme.txt || die "dodoc failed"

	# Not needed
	find "${D}" -name "*.la" -delete || die "failed *.la removal"
}

pkg_postinst() {
	gnome2_pkg_postinst

	alternatives_auto_makesym "/usr/bin/abiword" "/usr/bin/abiword-[0-9].[0-9]"
}

pkg_postrm() {
	gnome2_pkg_postrm

	alternatives_auto_makesym "/usr/bin/abiword" "/usr/bin/abiword-[0-9].[0-9]"
}
