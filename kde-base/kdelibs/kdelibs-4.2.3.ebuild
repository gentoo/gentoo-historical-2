# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdelibs/kdelibs-4.2.3.ebuild,v 1.4 2009/05/07 22:15:18 alexxy Exp $

EAPI="2"

CPPUNIT_REQUIRED="optional"
OPENGL_REQUIRED="optional"
WEBKIT_REQUIRED="always"
inherit kde4-base fdo-mime

DESCRIPTION="KDE libraries needed by all KDE programs."
HOMEPAGE="http://www.kde.org/"

KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~x86"
LICENSE="LGPL-2.1"
IUSE="3dnow acl alsa altivec bindist +bzip2 debug doc fam jpeg2k kerberos
mmx nls openexr +semantic-desktop spell sse sse2 ssl zeroconf"

RESTRICT="test"

COMMONDEPEND="
	>=app-misc/strigi-0.6.3[dbus,qt4]
	dev-libs/libpcre
	dev-libs/libxml2
	dev-libs/libxslt
	>=kde-base/automoc-0.9.87
	media-fonts/dejavu
	media-libs/fontconfig
	media-libs/freetype:2
	media-libs/giflib
	media-libs/jpeg
	media-libs/libpng
	>=media-sound/phonon-4.3.1[xcb]
	sys-apps/dbus[X]
	sys-libs/libutempter
	sys-libs/zlib
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXcursor
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXft
	x11-libs/libXpm
	x11-libs/libXrender
	x11-libs/libXtst
	x11-misc/shared-mime-info
	acl? (
		kernel_linux? ( sys-apps/acl )
	)
	alsa? ( media-libs/alsa-lib[midi] )
	bzip2? ( app-arch/bzip2 )
	fam? ( virtual/fam )
	jpeg2k? ( media-libs/jasper )
	kerberos? ( virtual/krb5 )
	openexr? (
		media-libs/openexr
		media-libs/ilmbase
	)
	semantic-desktop? ( >=dev-libs/soprano-2.2.2[dbus] )
	spell? (
		app-dicts/aspell-en
		app-text/aspell
		app-text/enchant
	)
	ssl? ( dev-libs/openssl )
	zeroconf? (
		|| (
			net-dns/avahi[mdnsresponder-compat]
			!bindist? ( net-misc/mDNSResponder )
		)
	)
"
DEPEND="${COMMONDEPEND}
	doc? ( app-doc/doxygen )
	nls? ( virtual/libintl )
"
# Blockers added for !kdeprefix? due to packages from old versions,
# removed in the meanwhile
# kde-base/libplasma
# kde-base/knewsticker
# kde-base/kpercentage
# kde-base/ktnef
RDEPEND="${COMMONDEPEND}
	!<=kde-base/kdebase-3.5.9-r4
	!<=kde-base/kdebase-startkde-3.5.10
	!<kde-base/kdelibs-3.5.10
	!x11-libs/qt-phonon
	!kdeprefix? (
		!kde-base/kitchensync:4.1
		!kde-base/knewsticker:4.1
		!kde-base/kpercentage:4.1
		!kde-base/ktnef:4.1
		!kde-base/libplasma
		!<=kde-misc/kdnssd-avahi-0.1.2:0
	)
	kdeprefix? (
		!<=kde-misc/kdnssd-avahi-0.1.2:0
	)
	x11-apps/iceauth
	x11-apps/rgb
	>=x11-misc/xdg-utils-1.0.2-r3
"
PDEPEND="
	>=kde-base/kde-env-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kdebase-data-${PV}:${SLOT}[kdeprefix=]
"

# upstream patches / dist patches
# systemsettings title issue
# ${FILESDIR}/${PN}-${SLOT}-fixx11h.h.patch - see bug 263823
PATCHES=(
	"${FILESDIR}/dist/09_disable_debug_messages_if_not_explicitly_enabled.patch"
	"${FILESDIR}/dist/20_use_dejavu_as_default_font.patch"
	"${FILESDIR}/dist/23_solid_no_double_build.patch"
	"${FILESDIR}/${PN}-${SLOT}-fixx11h.h.patch"
	"${FILESDIR}/${P}-halbattery_backport_fix.patch"
)

src_prepare() {
	sed -e 's/find_package(ACL)/macro_optional_find_package(ACL)/' \
		-i CMakeLists.txt || die "Failed to make ACL disabled even when present in system."

	# Rename applications.menu
	sed -e "s|FILES[[:space:]]applications.menu|FILES applications.menu RENAME kde-${SLOT}-applications.menu|g" \
		-i kded/CMakeLists.txt || die "Sed for applications.menu failed."

	kde4-base_src_prepare
}

src_configure() {
	if use zeroconf; then
		if has_version net-dns/avahi; then
			mycmakeargs="${mycmakeargs} -DWITH_Avahi=ON -DWITH_DNSSD=OFF"
		elif has_version net-misc/mDNSResponder; then
			mycmakeargs="${mycmakeargs} -DWITH_Avahi=OFF -DWITH_DNSSD=ON"
		else
			die "USE=\"zeroconf\" enabled but neither net-dns/avahi nor net-misc/mDNSResponder were found."
		fi
	else
		mycmakeargs="${mycmakeargs} -DWITH_Avahi=OFF -DWITH_DNSSD=OFF"
	fi
	if use kdeprefix; then
		HME=".kde${SLOT}"
	else
		HME=".kde4"
	fi
	mycmakeargs="${mycmakeargs}
		-DWITH_HSPELL=OFF
		-DKDE_DEFAULT_HOME=${HME}
		$(cmake-utils_use_has 3dnow X86_3DNOW)
		$(cmake-utils_use_has altivec PPC_ALTIVEC)
		$(cmake-utils_use_has mmx X86_MMX)
		$(cmake-utils_use_has sse X86_SSE)
		$(cmake-utils_use_has sse2 X86_SSE2)
		$(cmake-utils_use_with acl ACL)
		$(cmake-utils_use_with alsa Alsa)
		$(cmake-utils_use_with bzip2 BZip2)
		$(cmake-utils_use_with fam FAM)
		$(cmake-utils_use_with jpeg2k Jasper)
		$(cmake-utils_use_with kerberos GSSAPI)
		$(cmake-utils_use_with nls Libintl)
		$(cmake-utils_use_with openexr OpenEXR)
		$(cmake-utils_use_with opengl OpenGL)
		$(cmake-utils_use_with semantic-desktop Soprano)
		$(cmake-utils_use_with spell ASPELL)
		$(cmake-utils_use_with spell ENCHANT)
		$(cmake-utils_use_with ssl OpenSSL)
	"
	kde4-base_src_configure
}

src_compile() {
	kde4-base_src_compile

	# The building of apidox is not managed anymore by the build system
	if use doc; then
		einfo "Building API documentation"
		cd "${S}"/doc/api/
		./doxygen.sh "${S}" || die "APIDOX generation failed"
	fi
}

src_install() {
	kde4-base_src_install

	if use doc; then
		einfo "Installing API documentation. This could take a bit of time."
		cd "${S}"/doc/api/
		docinto /HTML/en/kdelibs-apidox
		dohtml -r ${P}-apidocs/* || die "Install phase of KDE4 API Documentation failed"
	fi
}

pkg_postinst() {
	fdo-mime_mime_database_update
	if use zeroconf; then
		echo
		elog "To make zeroconf support available in KDE make sure that the 'mdnsd' daemon"
		elog "is running. Make sure also that multicast dns lookups are enabled by editing"
		elog "the 'hosts:' line in /etc/nsswitch.conf to include 'mdns', e.g.:"
		elog "	hosts: files mdns dns"
		echo
	fi
	elog "Your homedir is set to "'${HOME}'"/${HME}"
	elog
	elog "If you experience weird application behavior (missing texts, etc.) run as root:"
	elog "# chmod 755 -R /usr/share/config $PREFIX/share/config"

	kde4-base_pkg_postinst
}

pkg_prerm() {
	# Remove ksycoca4 global database
	rm -f "${PREFIX}"/share/kde4/services/ksycoca4
}

pkg_postrm() {
	fdo-mime_mime_database_update

	kde4-base_pkg_postrm
}
