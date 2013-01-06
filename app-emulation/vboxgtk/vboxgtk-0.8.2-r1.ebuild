# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/vboxgtk/vboxgtk-0.8.2-r1.ebuild,v 1.3 2013/01/06 18:13:59 hasufell Exp $

EAPI=5
PYTHON_COMPAT=( python2_6 python2_7 )
PLOCALES="cs gl"
inherit gnome2-utils l10n distutils-r1

DESCRIPTION="GTK frontend for VirtualBox"
HOMEPAGE="http://code.google.com/p/vboxgtk/"
SRC_URI="http://vboxgtk.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	|| ( >=app-emulation/virtualbox-4.2.0[-headless,python,sdk]
		>=app-emulation/virtualbox-bin-4.2.0[python] )
	dev-python/pygobject:3
	x11-libs/gtk+:3[introspection]
	virtual/python-argparse[${PYTHON_USEDEP}]"
DEPEND="dev-util/intltool
	sys-devel/gettext"

DOCS=( AUTHORS README )

python_prepare_all() {
	distutils-r1_python_prepare_all
	rm_locale() { rm -r po/"${1}".po || die "LINGUAS removal failed" ;}
	l10n_for_each_disabled_locale_do rm_locale
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
