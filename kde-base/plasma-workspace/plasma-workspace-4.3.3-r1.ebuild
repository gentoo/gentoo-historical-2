# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/plasma-workspace/plasma-workspace-4.3.3-r1.ebuild,v 1.3 2009/11/29 18:30:29 armin76 Exp $

EAPI="2"

KMNAME="kdebase-workspace"
KMMODULE="plasma"
inherit python kde4-meta

DESCRIPTION="Plasma: KDE desktop framework"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="debug +handbook google-gadgets python rss +semantic-desktop xinerama"

COMMONDEPEND="
	$(add_kdebase_dep kephal)
	$(add_kdebase_dep ksysguard)
	$(add_kdebase_dep libkworkspace)
	$(add_kdebase_dep libplasmaclock)
	$(add_kdebase_dep libtaskmanager)
	$(add_kdebase_dep solid)
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXfixes
	x11-libs/libXrender
	google-gadgets? ( >=x11-misc/google-gadgets-0.10.5[qt4] )
	python? (
		>=dev-python/PyQt4-4.4.0[X]
		>=dev-python/sip-4.7.1
		$(add_kdebase_dep pykde4)
	)
	rss? ( $(add_kdebase_dep kdepimlibs) )
	semantic-desktop? ( $(add_kdebase_dep kdelibs 'semantic-desktop?') )
	xinerama? ( x11-libs/libXinerama )
"
DEPEND="${COMMONDEPEND}
	x11-proto/compositeproto
	x11-proto/damageproto
	x11-proto/fixesproto
	x11-proto/renderproto
	xinerama? ( x11-proto/xineramaproto )
"
RDEPEND="${COMMONDEPEND}
	$(add_kdebase_dep kioclient)
	$(add_kdebase_dep kdebase-menu-icons)
	$(add_kdebase_dep plasma-runtime)
	$(add_kdebase_dep soliduiserver)
"

KMEXTRA="
	libs/nepomukquery/
	libs/nepomukqueryclient/
"
KMEXTRACTONLY="
	krunner/dbus/org.freedesktop.ScreenSaver.xml
	krunner/dbus/org.kde.krunner.App.xml
	ksmserver/org.kde.KSMServerInterface.xml
	libs/kworkspace/
	libs/taskmanager/
	ksysguard/
"

KMLOADLIBS="libkworkspace libplasmaclock libtaskmanager"

PATCHES=(
	"${FILESDIR}/${PV}-progress_indicator.patch"
)

src_configure() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with google-gadgets Googlegadgets)
		$(cmake-utils_use_with python SIP)
		$(cmake-utils_use_with python PyQt4)
		$(cmake-utils_use_with python PyKDE4)
		$(cmake-utils_use_with rss KdepimLibs)
		$(cmake-utils_use_with semantic-desktop Nepomuk)
		$(cmake-utils_use_with semantic-desktop Soprano)
		-DWITH_Xmms=OFF"

	kde4-meta_src_configure
}

src_install() {
	kde4-meta_src_install

	python_version
	rm -f \
		"${D}/usr/$(get_libdir)/python${PYVER}"/site-packages/PyKDE4/*.py[co] \
		"${D}${KDEDIR}"/share/apps/plasma_scriptengine_python/*.py[co]
}

pkg_postinst() {
	kde4-meta_pkg_postinst

	if use python; then
		python_mod_optimize \
			"/usr/$(get_libdir)/python${PYVER}"/site-packages/PyKDE4 \
			"${KDEDIR}"/share/apps/plasma_scriptengine_python
	fi
}

pkg_postrm() {
	kde4-meta_pkg_postrm

	if [[ -d "${KDEDIR}"/share/apps/plasma_scriptengine_python ]]; then
		python_mod_cleanup \
			"/usr/$(get_libdir)/python${PYVER}"/site-packages/PyKDE4 \
			"${KDEDIR}"/share/apps/plasma_scriptengine_python
	fi
}
