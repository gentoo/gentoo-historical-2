# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Daniel Robbins <drobbins@gentoo.org> 
# $Header: /var/cvsroot/gentoo-x86/media-sound/alsa-driver/alsa-driver-0.9.0_rc1-r5.ebuild,v 1.1 2002/05/03 06:44:52 agenkin Exp $

DESCRIPTION="Advanced Linux Sound Architecture kernel modules"
HOMEPAGE="http://www.alsa-project.org/"

# By default, drivers for all supported cards will be compiled.
# If you want to only compile for specific card(s), set ALSA_CARDS
# environment variable accordingly
[ x${ALSA_CARDS} = x ] && ALSA_CARDS=all

SRC_URI="ftp://ftp.alsa-project.org/pub/driver/${P/_rc/rc}.tar.bz2"
S=${WORKDIR}/${P/_rc/rc}

#virtual/glibc should depend on specific kernel headers
DEPEND="sys-devel/autoconf
        virtual/glibc"
PROVIDE="virtual/alsa"


src_unpack() {
	# Some *broken* Gentoo packages install stuff in /etc/rc.d/init.d
	# instead of /etc/init.d.  However, this causes alsa's installer
	# to do the same foolish thing.  This *hack* inibits the problem.
	# I filed a bug report about this with the ALSA people:
	# http://sourceforge.net/tracker/?func=detail&aid=551668&group_id=27464&atid=390601
	unpack ${A}
	cd ${S}
	sed -e 's:/etc/rc.d/init.d:/etc/init.d:' < Makefile > Makefile.hacked
	mv Makefile.hacked Makefile
}


src_compile() {
	# Portage should determine the version of the kernel sources
	if [ x"${KV}" = x ]
	then
		eerror ""
		eerror "Could not determine you kernel version."
		eerror "Make sure that you have /usr/src/linux symlink."
		eerror ""
		die
	fi
	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--with-kernel="${ROOT}usr/src/linux-${KV}" \
		--with-isapnp=yes \
		--with-sequencer=yes \
		--with-oss=yes \
		--with-cards=${ALSA_CARDS} \
		|| die "./configure failed"
	
	emake || die "Parallel Make Failed"
}


src_install () {
	dodir /usr/include/sound
	dodir /etc/init.d
	make DESTDIR=${D} install || die

	dodoc CARDS-STATUS COPYING FAQ INSTALL README WARNING TODO doc/*

	insinto /etc/modules.d
	newins ${FILESDIR}/alsa-modules.conf alsa
	exeinto /etc/init.d
	doexe ${FILESDIR}/alsasound
}

pkg_postinst () {
	if [ "${ROOT}" = / ]
	then
		[ -x /usr/sbin/update-modules ] && /usr/sbin/update-modules
	fi

	einfo
	einfo "You might want to edit file /etc/modules.d/alsa according to your"
	einfo "hardware configuration."
	einfo
}
