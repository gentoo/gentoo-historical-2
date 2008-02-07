# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kopete/kopete-4.0.1.ebuild,v 1.1 2008/02/07 00:10:48 philantrop Exp $

EAPI="1"

KMNAME=kdenetwork
inherit kde4-meta

DESCRIPTION="KDE multi-protocol IM client"
KEYWORDS="~amd64 ~x86"
IUSE="+addbookmarks +alias +autoreplace +contactnotes debug gadu groupwise
+highlight +history htmlhandbook +jabber latex +msn +nowlistening oscar
+privacy qq sms +statistics testbed +texteffect +translator
+urlpicpreview +webpresence winpopup yahoo"
# telepathy is broken.

#IUSE="irc jingle meanwhile messenger oscar ppp	qq rdesktop ssl"

# plugins: addbookmarks, autoreplace, contactnotes, history, nowlistening,
# (sqlite?) statistics, translator, (&& xml2 xslt) webpresence, alias, highlight,
# latex, privacy, texteffect, urlpicpreview

# protocols: (qca2?) groupwise, (&& qca2 idn) jabber, messenger, oscar, sms,
# testbed, yahoo, (ssl?) gadu, irc (disabled), meanwhile, msn, qq, (decibel?) telepathy, winpopup

#		meanwhile hasn't been ported to KDE4 yet (4.0.1)
#		jingle and irc are disabled in the package (4.0.1)
#		messenger is the new msn support protocol (it's not ready yet; 4.0.1)

# Tests are KDE-ish.
RESTRICT="test"

RDEPEND="
	dev-libs/libpcre
	kde-base/qimageblitz
	x11-libs/libXScrnSaver
	gadu? ( dev-libs/openssl )
	groupwise? ( app-crypt/qca:2 )
	jabber? ( net-dns/libidn app-crypt/qca:2 )
	statistics? ( dev-db/sqlite:3 )
	webpresence? ( dev-libs/libxml2 dev-libs/libxslt )"
# 	telepathy? ( net-libs/decibel )

DEPEND="${RDEPEND}
	x11-proto/scrnsaverproto"

src_compile() {
	# Translated protocol causing bug 206877.
	sed -e '/X-KDE-PluginInfo-Category\[.*/d' \
		-i "${S}"/kopete/protocols/*/kopete_*.desktop || die "Sed failed."

	# Xmms isn't in portage, thus forcefully disabled.
	#	$(cmake-utils_use_with messenger)
	mycmakeargs="${mycmakeargs}
		-DWITH_Xmms=OFF
		-DWITH_telepathy=OFF
		-DWITH_messenger=OFF
		$(cmake-utils_use_with addbookmarks)
		$(cmake-utils_use_with alias)
		$(cmake-utils_use_with autoreplace)
		$(cmake-utils_use_with contactnotes)
		$(cmake-utils_use_with gadu OPENSSL)
		$(cmake-utils_use_with groupwise)
		$(cmake-utils_use_with groupwise QCA2)
		$(cmake-utils_use_with highlight)
		$(cmake-utils_use_with history)
		$(cmake-utils_use_with jabber IDN)
		$(cmake-utils_use_with jabber QCA2)
		$(cmake-utils_use_with latex)
		$(cmake-utils_use_with msn)
		$(cmake-utils_use_with nowlistening)
		$(cmake-utils_use_with oscar)
		$(cmake-utils_use_with privacy)
		$(cmake-utils_use_with qq)
		$(cmake-utils_use_with sms)
		$(cmake-utils_use_with statistics Sqlite)
		$(cmake-utils_use_with statistics)
		$(cmake-utils_use_with testbed)
		$(cmake-utils_use_with texteffect)
		$(cmake-utils_use_with translator)
		$(cmake-utils_use_with urlpicpreview)
		$(cmake-utils_use_with webpresence LibXml2)
		$(cmake-utils_use_with webpresence LibXslt)
		$(cmake-utils_use_with webpresence)
		$(cmake-utils_use_with winpopup)
		$(cmake-utils_use_with yahoo)"

#		$(cmake-utils_use_with messenger)
#		$(cmake-utils_use_with telepathy)
#		$(cmake-utils_use_with telepathy Decibel)

	kde4-meta_src_compile
}

pkg_postinst() {
#	if use telepathy; then
#		elog "To use kopete telepathy plugins, you need to start gabble first:"
#		elog "GABBLE_PERSIST=1 telepathy-gabble &"
#		elog "export TELEPATHY_DATA_PATH=/usr/share/telepathy/managers/"
#	fi
	if use jabber; then
		echo
		elog "In order to use ssl in jabber, messenger and irc you'll need to have qca-ossl"
		echo
	fi
}
