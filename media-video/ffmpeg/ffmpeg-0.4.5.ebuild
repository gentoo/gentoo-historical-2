# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Ryan Tolboom <ryan@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/media-video/ffmpeg/ffmpeg-0.4.5.ebuild,v 1.1 2001/12/07 21:24:21 ryan Exp $

A=${P}.tar.gz
S=${WORKDIR}/ffmpeg
DESCRIPTION="Tool to manipulate and stream video files"
SRC_URI="http://prdownloads.sourceforge.net/ffmpeg/${A}"

DEPEND="virtual/glibc"

RDEPEND="virtual/glibc"

src_compile() {

	local myconf

	if [ -z "`use mmx`" ] ; then
		myconf="--disable-mmx"
	fi

	try ./configure ${myconf}
	try make
}

src_install() {

	dobin ffmpeg ffserver
	dodoc doc/*

}
