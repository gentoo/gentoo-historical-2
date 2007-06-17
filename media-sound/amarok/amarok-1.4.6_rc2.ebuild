# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/amarok/amarok-1.4.6_rc2.ebuild,v 1.1 2007/06/17 21:15:35 flameeyes Exp $

LANGS="af ar az be bg bn br ca cs cy da de el en_GB eo es et eu fa fi
fr ga gl he hi hu id is it ja km ko ku lo lt mk ms nb nds nl nn pa pl
pt pt_BR ro ru rw se sk sl sq sr sr@Latn ss sv ta tg th tr uk uz zh_CN
zh_TW"
LANGS_DOC="da de es et fr it nl pl pt pt_BR ru sv"

USE_KEG_PACKAGING=1

inherit kde eutils flag-o-matic

PKG_SUFFIX=""

if [[ ${P/_pre} == ${P} ]]; then
	MY_P="${P/_/-}"

	if [[ ${P/_rc} == ${P} ]]; then
		SRC_URI="mirror://kde/stable/amarok/${PV}/src/${MY_P}.tar.bz2"
		S="${WORKDIR}/${P/_/-}"
	else
		SRC_URI="mirror://gentoo/${MY_P}.tar.bz2"
		S="${WORKDIR}/${P/_rc*}"
	fi
else
	SRC_URI="mirror://gentoo/${P}.tar.bz2"
fi

DESCRIPTION="Advanced audio player based on KDE framework."
HOMEPAGE="http://amarok.kde.org/"

LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="aac kde mysql noamazon opengl postgres
visualization ipod ifp real njb mtp musicbrainz daap
python"
# kde: enables compilation of the konqueror sidebar plugin

SQLITEVER="3.3.17"

RDEPEND="kde? ( || ( kde-base/konqueror kde-base/kdebase ) )
	>=media-libs/xine-lib-1.1.2_pre20060328-r8
	>=media-libs/taglib-1.4
	mysql? ( >=virtual/mysql-4.0 )
	postgres? ( dev-db/libpq )
	opengl? ( virtual/opengl )
	visualization? ( media-libs/libsdl
					 =media-plugins/libvisual-plugins-0.4* )
	ipod? ( >=media-libs/libgpod-0.4.2 )
	aac? ( media-libs/libmp4v2 )
	ifp? ( media-libs/libifp )
	real? ( media-video/realplayer )
	njb? ( >=media-libs/libnjb-2.2.4 )
	mtp? ( >=media-libs/libmtp-0.1.1 )
	musicbrainz? ( media-libs/tunepimp )
	=dev-lang/ruby-1.8*
	>=dev-db/sqlite-${SQLITEVER}"

DEPEND="${RDEPEND}"

RDEPEND="${RDEPEND}
	app-arch/unzip
	python? ( dev-python/PyQt )
	daap? ( www-servers/mongrel )"

need-kde 3.3

pkg_setup() {
	if built_with_use ">=dev-db/sqlite-${SQLITEVER}" nothreadsafe; then
		eerror "SQLite was built without thread safety."
		eerror "Amarok requires thread safety enabled in SQLite."
		eerror "Please rebuild >=dev-db/sqlite-${SQLITEVER} with the"
		eerror "nothreadsafe USE flag disabled."
		die "SQLite built with nothreadsafe USE flag."
	fi
}

src_compile() {
	# Extra, unsupported engines are forcefully disabled.
	local myconf="$(use_enable mysql) $(use_enable postgres postgresql)
				  $(use_with opengl) --without-xmms
				  $(use_with visualization libvisual)
				  $(use_enable !noamazon amazon)
				  $(use_with ipod libgpod)
				  $(use_with aac mp4v2)
				  $(use_with ifp)
				  $(use_with real helix)
				  $(use_with njb libnjb)
				  $(use_with mtp libmtp)
				  $(use_with musicbrainz)
				  $(use_with daap)
				  --with-xine
				  --without-mas
				  --without-nmm
				  --without-included-sqlite"

	kde_src_compile
}

src_install() {
	kde_src_install

	# As much as I respect Ian, I'd rather leave Amarok to use mongrel
	# from Portage, for security and policy reasons.
	rm -rf "${D}"/usr/share/apps/amarok/ruby_lib/rbconfig \
		"${D}"/usr/share/apps/amarok/ruby_lib/mongrel* \
		"${D}"/usr/share/apps/amarok/ruby_lib/rubygems* \
		"${D}"/usr/share/apps/amarok/ruby_lib/gem* \
		"${D}"/usr/$(get_libdir)/ruby_lib

	if ! use python; then
		rm -r "${D}"/usr/share/apps/amarok/scripts/webcontrol \
			|| die "Unable to remove webcontrol."
	fi
}
