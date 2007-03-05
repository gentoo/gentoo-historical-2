# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/bicyclerepair/bicyclerepair-0.7.1-r1.ebuild,v 1.5 2007/03/05 02:40:53 genone Exp $

inherit distutils
mydoc="NEWS DESIGN"


DESCRIPTION="Bicycle Repair Man is the Python Refactoring Browser,"
HOMEPAGE="http://bicyclerepair.sourceforge.net/"
SRC_URI="mirror://sourceforge/bicyclerepair/${P}.tar.gz"
LICENSE="as-is"
SLOT="0"
KEYWORDS="x86 ~ppc"
IUSE=""
DEPEND="virtual/python"

src_install() {
	distutils_src_install
	insinto /usr/share/${PN}
	doins ide-integration/bike.el
	rm -f ${D}/usr/bin/bikeemacs.bat
}

pkg_postinst() {
	# Enable IDLE integration if Python was compiled with tcltk.
	PYTHON_VER=$(python -V 2>&1 | sed -e 's:Python \([0-9].[0-9]\).*:\1:')
	config_txt=/usr/lib/python${PYTHON_VER}/tools/idle/config.txt
	if [ -f "${config_txt}" ];
	then
		if [ -z "`grep BicycleRepairMan_Idle ${config_txt}`" ]; then
			elog "Appending BicycleRepairman to IDLE.."
			echo "[BicycleRepairMan_Idle]" >> ${config_txt}
		fi
	else
		elog "BicycleRepairMan won't integrate with IDLE included in Python 2.3*"
	fi
	elog
	elog "To use bicyclerepair with Xemacs or GNU Emacs you must be in Python"
	elog "mode and add this to your .emacs or .init.el:"
	elog "(load-library '/usr/share/bicyclerepair/bike.el')"
}

