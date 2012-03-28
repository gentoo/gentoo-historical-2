# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/qtwitter/qtwitter-0.10.0-r1.ebuild,v 1.1 2012/03/28 13:48:58 johu Exp $

EAPI=4

LANGS="nb_NO pt_BR"
LANGSLONG="ca_ES cs_CZ de_DE es_ES fr_FR it_IT ja_JP pl_PL"

inherit qt4-r2

DESCRIPTION="A Qt-based microblogging client"
HOMEPAGE="http://www.qt-apps.org/content/show.php/qTwitter?content=99087"
SRC_URI="http://files.ayoy.net/qtwitter/release/${PV}/src/${P}-src.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="x11-libs/libX11
	>=x11-libs/qt-core-4.5:4
	>=x11-libs/qt-gui-4.5:4
	>=x11-libs/qt-dbus-4.5:4
	>=dev-libs/qoauth-1.0"
RDEPEND="${DEPEND}"

DOCS="README CHANGELOG"
PATCHES=( "${FILESDIR}/${P}-gold.patch" )

src_prepare() {
	qt4-r2_src_prepare

	echo "CONFIG += nostrip" >> "${S}"/${PN}.pro

	local langs=
	for lingua in $LINGUAS; do
		if has $lingua $LANGS; then
			langs="$langs ${lingua}"
		else
			for a in $LANGSLONG; do
				if [[ $lingua == ${a%_*} ]]; then
					langs="$langs ${a}"
				fi
			done
		fi
	done

	# remove translations and add only the selected ones
	sed -e '/^ *LANGS/,/^$/s/^/#/' \
		-e "/LANGS =/s/.*/LANGS = ${langs}/" \
		-i translations/translations.pri || die "sed translations failed"

	# fix insecure runpaths
	sed -e '/-Wl,-rpath,\$\${DESTDIR}/d' \
		-i qtwitter-app/qtwitter-app.pro || die "sed rpath failed"

	# to pass validation
	sed -e 's/Instant Messaging/InstantMessaging/' \
		-i qtwitter-app/x11/qtwitter.desktop || die "sed .desktop failed"
}

src_configure() {
	eqmake4 PREFIX="/usr"
}
