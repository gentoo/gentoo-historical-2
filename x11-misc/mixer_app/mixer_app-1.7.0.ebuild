# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/mixer_app/mixer_app-1.7.0.ebuild,v 1.6 2004/04/16 00:19:08 weeve Exp $

#need to do some name mangling
#so that ebuild name adheres to "standart"
Name=Mixer.app
S=${WORKDIR}/${Name}-${PV}

DESCRIPTION="Mixer.app is a mixer utility that has three volume controllers that can be configured to handle any sound source, the default sources are master-, cd- and pcm-volume."
SRC_URI="http://www.fukt.bth.se/~per/mixer/${Name}-${PV}.tar.gz"
HOMEPAGE="http://www.fukt.bth.se/~per/mixer/"
DEPEND="virtual/glibc x11-base/xfree "

LICENSE="GPL-2"

SLOT="0"
KEYWORDS="x86 sparc "

src_compile() {
	emake || die

}

src_install () {
	#make DESTDIR=${D} install || die
	dobin Mixer.app

	dodoc COPYING README ChangeLog
}

