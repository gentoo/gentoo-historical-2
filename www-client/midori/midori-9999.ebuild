# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/midori/midori-9999.ebuild,v 1.15 2010/03/31 15:03:48 ssuominen Exp $

EAPI=2

PYTHON_DEPEND="2:2.6"

inherit eutils multilib python xfconf git

DESCRIPTION="A lightweight web browser"
HOMEPAGE="http://www.twotoasts.de/index.php?/pages/midori_summary.html"
EGIT_REPO_URI="git://git.xfce.org/apps/midori"
EGIT_PROJECT="midori"
SRC_URI=""

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS=""
IUSE="doc gnome html idn libnotify nls +sqlite +unique"

RDEPEND="libnotify? ( x11-libs/libnotify )
	>=net-libs/libsoup-2.25.2
	>=net-libs/webkit-gtk-1.1.1
	dev-libs/libxml2
	x11-libs/gtk+
	gnome? ( net-libs/libsoup[gnome] )
	idn? ( net-dns/libidn )
	sqlite? ( >=dev-db/sqlite-3.0 )
	unique? ( dev-libs/libunique )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( dev-util/gtk-doc )
	html? ( dev-python/docutils )
	nls? ( sys-devel/gettext )"

pkg_setup() {
	python_set_active_version 2
}

src_prepare() {
	# moving docs to version-specific directory
	sed -i -e "s:\${DOCDIR}/${PN}:\${DOCDIR}/${PF}/:g" wscript
	sed -i -e "s:/${PN}/user/midori.html:/${PF}/user/midori.html:g" midori/midori-browser.c
}

src_configure() {
	strip-linguas -i po

	CCFLAGS="${CFLAGS}" LINKFLAGS="${LDFLAGS}" ./waf \
		--prefix="/usr/" \
		--libdir="/usr/$(get_libdir)" \
		--disable-docs \
		$(use_enable doc apidocs) \
		$(use_enable html userdocs) \
		$(use_enable idn libidn) \
		$(use_enable nls nls) \
		$(use_enable sqlite) \
		$(use_enable unique) \
		configure || die "configure failed"
}

src_compile() {
	NUMJOBS=$(sed -e 's/.*\(\-j[ 0-9]\+\) .*/\1/; s/--jobs=\?/-j/' <<< ${MAKEOPTS})
	./waf build ${NUMJOBS} || die "build failed"
}

src_install() {
	DESTDIR=${D} ./waf install || die "install failed"
	rm -r "${D}"/usr/share/doc/${PN}
	dodoc AUTHORS ChangeLog INSTALL TODO || die "dodoc failed"
}

pkg_postinst() {
	xfconf_pkg_postinst
	ewarn "Midori tends to crash due to bugs in WebKit."
	ewarn "Report bugs at http://www.twotoasts.de/bugs"
}
