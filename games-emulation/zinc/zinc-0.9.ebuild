# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/zinc/zinc-0.9.ebuild,v 1.6 2004/07/01 11:16:17 eradicator Exp $

DESCRIPTION="ZiNc is an x86 binary-only emulator for the Sony ZN-1, ZN-2, and Namco System 11 arcade systems."
HOMEPAGE="http://www.emuhype.com/"
SRC_URI="http://www.emuhype.com/files/${P}-linux.tar.bz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="x86 -ppc -sparc"
IUSE=""

DEPEND="virtual/libc
	virtual/x11
	virtual/opengl"

S="${WORKDIR}/zinc"

src_install() {
	exeinto /opt/bin
	doexe zinc
	dolib.so libcontrolznc.so librendererznc.so libsoundznc.so
}
