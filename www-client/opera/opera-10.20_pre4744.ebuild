# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/opera/opera-10.20_pre4744.ebuild,v 1.7 2010/02/16 18:13:18 jer Exp $

EAPI="2"

GCONF_DEBUG="no"

inherit eutils gnome2

DESCRIPTION="A standards-compliant graphical Web browser"
HOMEPAGE="http://www.opera.com/"

SLOT="0"
LICENSE="OPERA-10.10"
KEYWORDS="~amd64 ~x86"

RESTRICT="mirror test"

QA_DT_HASH="opt/${PN}/.*"
QA_PRESTRIPPED="
	opt/${PN}/lib/${PN}/${PV/_pre*}/missingsyms.so
	opt/${PN}/lib/${PN}/${PV/_pre*}/spellcheck.so
	opt/${PN}/lib/${PN}/${PV/_pre*}/opera
	opt/${PN}/lib/${PN}/${PV/_pre*}/works
	opt/${PN}/lib/${PN}/${PV/_pre*}/operaplugincleaner
	opt/${PN}/lib/${PN}/${PV/_pre*}/operapluginwrapper
"
QA_PRESTRIPPED_amd64="
	${QA_PRESTRIPPED}
	opt/${PN}/lib/${PN}/${PV/_pre*}/operapluginwrapper-ia32-linux
	opt/${PN}/lib/${PN}/${PV/_pre*}/operapluginwrapper-native
"

IUSE="gnome qt-static"
MY_LINGUAS="be bg cs da de el en-GB es-ES es-LA et fi fr fr-CA fy hi hr hu id it ja ka ko lt mk nb nl nn pl pt pt-BR ro ru sk sr sv ta te tr uk zh-CN zh-HK zh-TW"

for MY_LINGUA in ${MY_LINGUAS}; do
	IUSE="${IUSE} linguas_${MY_LINGUA/-/_}"
done

O_U="http://snapshot.opera.com/unix/snapshot-4744/"
O_P="${P/_pre/-}"

SRC_URI="
	amd64? (
		qt-static? ( ${O_U}x86_64-linux/${O_P}.gcc4-bundled-qt4.x86_64.tar.bz2 )
		!qt-static? ( ${O_U}x86_64-linux/${O_P}.gcc4-qt4.x86_64.tar.bz2 )
	)
	x86? (
		qt-static? ( ${O_U}intel-linux/${O_P}.gcc4-bundled-qt4.i386.tar.bz2 )
		!qt-static? ( ${O_U}intel-linux/${O_P}.gcc4-qt4.i386.tar.bz2 )
	)
	"

DEPEND=">=sys-apps/sed-4"

RDEPEND="
	media-libs/jpeg
	media-libs/libexif
	>=media-libs/fontconfig-2.1.94-r1
	x11-libs/libXrandr
	x11-libs/libXp
	x11-libs/libXmu
	x11-libs/libXi
	x11-libs/libXft
	x11-libs/libXext
	x11-libs/libXcursor
	x11-libs/libX11
	x11-libs/libSM
	x11-libs/libICE
	amd64? (
		qt-static? ( media-libs/nas )
		!qt-static? ( x11-libs/qt-gui )
	)
	x86? (
		qt-static? ( media-libs/nas )
		!qt-static? ( x11-libs/qt-gui )
	)
	x86-fbsd? ( =x11-libs/qt-3*[-immqt] )
	"

opera_linguas() {
	# Remove unwanted LINGUAS:
	local LINGUA
	local LNGDIR="${D}/opt/opera/share/opera/locale"
	einfo "Keeping these locales: ${LINGUAS}."
	for LINGUA in ${MY_LINGUAS}; do
		if ! use linguas_${LINGUA/-/_}; then
			LINGUA=$(find "${LNGDIR}" -maxdepth 1 -type d -iname ${LINGUA/_/-})
			rm -r "${LINGUA}"
		fi
	done
}

pkg_setup() {
	echo -e \
		" ${GOOD}****************************************************${NORMAL}"
	elog "If you seek support, please file a bug report at"
	elog "https://bugs.gentoo.org and post the output of"
	elog " \`emerge --info =${CATEGORY}/${P}'"
	echo -e \
		" ${GOOD}****************************************************${NORMAL}"
}

src_unpack() {
	unpack ${A}
	if [[ ! -d ${S} ]]; then
		cd "${WORKDIR}"/${PN}* || die "failed to enter work directory"
		S="$(pwd)"
		einfo "Setting WORKDIR to ${S}"
	fi
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-gentoo.patch"
	epatch "${FILESDIR}/${PN}-simplify-desktop.patch"
	epatch "${FILESDIR}/${PN}-freedesktop.patch"

	# bug #181300:
	epatch "${FILESDIR}/${PN}-10.00-pluginpath.patch"

	sed -e "s|config_dir=\"/etc\"|config_dir=\"${D}/etc/\"|g" \
		-e "s|\(str_localdirplugin=\).*$|\1/opt/opera/lib/opera/plugins|" \
		-e 's|#\(export LD_PRELOAD OPERA_FORCE_JAVA_ENABLED\)|\1|' \
		-e 's|#\(OPERA_FORCE_JAVA_ENABLED=\)|\1|' \
		-e '/md5check Manifest.md5/d' \
		-i install.sh || die "sed failed"
}

# These workarounds are sadly needed because gnome2.eclass doesn't check
# whether a configure/Makefile script exists.
src_configure() { :; }
src_compile() { :; }

src_install() {
	# Prepare installation directories for Opera's installer script.
	dodir /etc

	# Opera's native installer.
	./install.sh --prefix="${D}"/opt/opera || die "install.sh failed"

	einfo "It is safe to ignore warnings about files that would be ignored."
	einfo "Completing the installation where install.sh abandoned us ..."

	# java workaround
	sed -i -e 's:LD_PRELOAD="${OPERA_JAVA_DIR}/libawt.so":LD_PRELOAD="$LD_PRELOAD"\:"${OPERA_JAVA_DIR}/libawt.so":' "${D}"/opt/opera/bin/opera

	dosed /opt/opera/bin/opera
	dosed /opt/opera/share/opera/java/opera.policy

	# Adapt desktop file to Gnome when needed
	use gnome && sed -i -e s:"GenericName\[":"Comment\[": "${D}"/usr/share/applications/opera.desktop

	# Install a symlink /usr/bin/opera
	dodir /usr/bin
	dosym /opt/opera/bin/opera /usr/bin/opera

	dodir /etc/revdep-rebuild
	echo 'SEARCH_DIRS_MASK="/opt/opera/lib/opera/plugins"' > "${D}"/etc/revdep-rebuild/90opera

	# Add the Opera man dir to MANPATH:
	insinto /etc/env.d
	echo 'MANPATH="/opt/opera/share/man"' >> "${D}"/etc/env.d/90opera

	[[ -z MY_LINGUAS ]] || opera_linguas
}

pkg_postinst() {
	use gnome && gnome2_pkg_postinst

	elog "To change the UI language, choose [Tools] -> [Preferences], open the"
	elog "[General] tab, click on [Details...] then [Choose...] and point the"
	elog "file chooser at /opt/opera/share/opera/locale/, then enter the"
	elog "directory for the language you want and [Open] the .lng file."
}

pkg_postrm() {
	use gnome && gnome2_pkg_postrm
}
