# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/cinelerra/cinelerra-1.0.0.ebuild,v 1.5 2002/11/15 09:38:49 raker Exp $

S=${WORKDIR}/hvirtual-${PV}

DESCRIPTION="Cinelerra - Professional Video Editor"
HOMEPAGE="http://heroinewarrior.com/cinelerra.php3"
SRC_URI="mirror://sourceforge/heroines/hvirtual-${PV}-src.tar.bz2"

DEPEND="virtual/x11
	virtual/glibc
	=sys-devel/gcc-3*"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

inherit gcc                                                                     
export WANT_GCC_3="yes"

src_compile() {

	echo ${CFLAGS} > i686/c_flags

	make || die "make failed"

}

src_install() {

	cd ${S}/${PN}/i686

	dobin ${PN} 

	cd ${S}/plugins
	insinto /usr/lib/${PN}
	doins i686/*.plugin
	doins titler/fonts

	cd ${S}/libmpeg3/i686
	dobin mpeg3dump mpeg3cat mpeg3toc 

	cd ${S}/mix/i686
	dobin mix2000

	cd ${S}/xmovie/i686
	dobin xmovie

	cd ${S}/mplexhi/i686
	dobin mplexhi

	cd ${S}/mplexlo/i686
	dobin mplexlo

	cd ${S} 
	dodoc CVS COPYING 
	dohtml -a png,html,texi,sdw -r doc/*	

}


