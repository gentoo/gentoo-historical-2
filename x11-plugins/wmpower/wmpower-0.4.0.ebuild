# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmpower/wmpower-0.4.0.ebuild,v 1.1 2005/02/23 09:34:06 s4t4n Exp $

IUSE=""

DESCRIPTION="WMaker DockApp to get (and set) power management status for laptops. Supports APM and ACPI kernels. Supports CPUfreq. Also has special support for Toshiba, Dell and Compal hardware."
HOMEPAGE="http://wmpower.sourceforge.net/"
SRC_URI="mirror://sourceforge/wmpower/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc"

DEPEND="virtual/x11"

src_compile()
{
	# override wmpower self-calculated cflags
	econf MY_CFLAGS="${CFLAGS}" || die "Configuration failed"
	emake prefix="/usr/" || die "Compilation failed"
}

src_install()
{
	einstall || die "Installation failed"
	dodoc AUTHORS BUGS COPYING ChangeLog LEGGIMI NEWS README README.compal THANKS TODO
}
