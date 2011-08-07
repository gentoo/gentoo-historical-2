# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/lastfmplayer/lastfmplayer-1.5.4.27091-r1.ebuild,v 1.4 2011/08/07 12:36:36 xarthisius Exp $

EAPI=2
inherit eutils multilib toolchain-funcs qt4-r2

MY_P="${P/lastfmplayer/lastfm}+dfsg"

DESCRIPTION="A player for last.fm radio streams"
HOMEPAGE="http://www.last.fm/help/player
	http://www.mehercule.net/staticpages/index.php/lastfm"
SRC_URI="http://dev.gentoo.org/~hwoarang/distfiles/lastfm-${PV}+dfsg.tar.gz
	http://dev.gentoo.org/~hwoarang/distfiles/lastfm_${PV}+dfsg-2.debian.tar.gz
	dbus? ( http://glue.umd.edu/~rossatok/dbusextension-2.0.tar.bz2 )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc x86"
IUSE="dbus ipod"

RDEPEND="x11-libs/qt-gui:4
	x11-libs/qt-sql:4
	media-libs/libsamplerate
	sci-libs/fftw
	media-libs/libmad
	ipod? ( >=media-libs/libgpod-0.5.2 )
	media-libs/alsa-lib"
DEPEND="${RDEPEND}
	app-arch/sharutils"

S=${WORKDIR}/${MY_P}

src_prepare() {
	qt4-r2_src_prepare
	# Use a different extensions path
	epatch "${FILESDIR}"/${PN}-extensions-path.patch
	einfo "Applying Debian patchset"
	sed -i "/^tray-icon-size.diff/d" "${WORKDIR}"/debian/patches/series
	cd "${S}"
	for i in $( < "${WORKDIR}"/debian/patches/series); do
		epatch "${WORKDIR}"/debian/patches/$i
	done
	if ! use ipod ; then
		sed -i '/src\/mediadevices\/ipod/d' LastFM.pro || die "sed failed"
	fi
	#fix plugin search path for multilib support
	sed -i -e "s:/usr/lib/:/usr/$(get_libdir)/:g" \
		"${S}"/src/libMoose/MooseCommon.cpp
	if use dbus; then
		mv "${WORKDIR}"/dbus "${S}"/src/dbus
		sed -i -e "/include/s:../definitions.pro.in:definitions.pro.in:" \
			-e "/TARGET/s:dbusextension:LastFmDbusExtension:" \
			"${S}"/src/dbus/dbusextension.pro
	fi
}

src_configure() {
	if use dbus; then
		pushd "${S}"/src/dbus
		eqmake4 dbusextension.pro
		popd >> /dev/null
	fi
	qt4-r2_src_configure
}

src_compile() {
	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)" || die "emake failed"
	if use dbus; then
		einfo "Building DBUS plugin"
		emake -C "${S}"/src/dbus || die "failed to build dbus extension"
	fi
	cd i18n; lrelease *.ts
}

src_install() {
	cd "${WORKDIR}"
	# Docs
	dodoc "${S}"/ChangeLog.txt "${S}"/README debian/README.source \
		|| die "dodoc failed"
	doman debian/lastfm.1 || die "doman failed"

	# Copied from debian/rules
	insinto /usr/share
	doins -r debian/package-files/share/icons || die "failed to install icons"
	insinto /usr/share/lastfm/icons
	doins "${S}"/bin/data/icons/*.png \
		|| die "failed to install application icons"
	insinto /usr/share/lastfm
	doins "${S}"/bin/data/*.png || die "failed to install icons"
	dodir /usr/$(get_libdir)/lastfm_services/
	insinto /usr/$(get_libdir)/lastfm_services/
	insopts -m0755
	doins -r "${S}"/bin/lastfm_services/*.so || die "failed to install plugins"
	if use dbus; then
		insinto /usr/$(get_libdir)/lastfm_services/extensions/
		insopts -m0755
		doins "${S}"/bin/lastfm_services/extensions/*.so || die
	fi
	insinto /usr/$(get_libdir)
	insopts -m0755
	doins "${S}"/bin/libLastFmTools.so.1* || die "failed to install library"
	doins "${S}"/bin/libMoose.so.1* || die "failed to install library"
	#fix symlinks
	cd "${D}"/usr/$(get_libdir)/
	ln -sfn libLastFmTools.so.1.0.0 libLastFmTools.so.1
	ln -sfn libLastFmTools.so.1.0.0 libLastFmTools.so.1.0
	ln -sfn libMoose.so.1.0.0 libMoose.so.1
	ln -sfn libMoose.so.1.0.0 libMoose.so.1.0
	cd "${WORKDIR}"
	newbin "${S}"/bin/last.fm lastfm || die "newbin failed"
	insinto /usr/share/lastfm/i18n
	doins "${S}"/i18n/*.qm || die "failed to install translations"
	fperms 755 /usr/bin/lastfm
	rm -f "${D}"/usr/share/lastfm/icons/{*profile24,systray_mac}.png
	# create desktop entry
	doicon "${WORKDIR}"/debian/package-files/share/icons/hicolor/48x48/apps/lastfm.png
	make_desktop_entry lastfm "Last.fm Player" lastfm
}

pkg_postinst() {
	elog "To use the Last.fm player with a mozilla based browser:"
	elog " 1. Install gnome-base/gconf"
	elog " 2. gconftool-2 -t string -s \
/desktop/gnome/url-handlers/lastfm/command \"/usr/bin/lastfm %s\""
	elog " 3. gconftool-2 -s \
/desktop/gnome/url-handlers/lastfm/needs_terminal false -t bool"
	elog " 4. gconftool-2 -t bool -s \
/desktop/gnome/url-handlers/lastfm/enabled true"
	elog
	elog "If you experience awkward fonts or widgets, try running qtconfig."
}
