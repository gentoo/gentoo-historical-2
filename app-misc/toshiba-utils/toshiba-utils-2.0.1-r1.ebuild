# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/toshiba-utils/toshiba-utils-2.0.1-r1.ebuild,v 1.7 2002/11/30 21:31:19 vapier Exp $

S=${WORKDIR}/toshutils-${PV}
DESCRIPTION="Toshiba Laptop Utilities"
HOMEPAGE="http://www.buzzard.org.uk/toshiba/"
SRC_URI="http://www.buzzard.org.uk/toshiba/toshutils-${PV}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 -ppc -sparc -sparc64"
IUSE="X gtk"

DEPEND="gtk? ( =x11-libs/gtk+-1* )"

src_unpack() {
	unpack ${A} ; cd ${S}
	rm -f config.{cache,log,status} src/*.o

	mv src/Makefile.in src/Makefile.in.orig
	sed -e "s:-m486 -O2::" \
		-e "s:\(^CFLAGS =.*\):\1 ${CFLAGS}:" \
		-e "s:^install\:.*:install\: all install-prog:" \
		src/Makefile.in.orig > src/Makefile.in

	use X || patch -p1 < ${FILESDIR}/${P}-gentoo.diff || die
	autoconf || die
}

src_compile() {
	econf
	make depend
	make -C src || die
}

src_install() {
	dodir /usr/bin
	make -C src DESTDIR=${D} install || die

	dodoc README* TODO CONTRIBUTE FAQ ChangeLog
	doman doc/*.{1x,1,8}
	docinto pdf ; dodoc doc/*.pdf

	insinto /etc/modules.d
	newins ${FILESDIR}/toshiba-modules.d toshiba
}

pkg_postinst() {
	ewarn "Dont forget Toshiba Laptop Support for your kernel."
	ewarn "(under Processor Type and Features, CONFIG_TOSHIBA)"
	/usr/sbin/update-modules || return 0
}

pkg_config() {
	# use this only if you dont have devfs... the driver is already devfs aware.
	if [ "`ls -l ${ROOT}/dev/toshiba 2>/dev/null | awk '{print $$6}'`" != "181" ]
	then
		rm -f ${ROOT}/dev/toshiba
		mknod -m 666 ${ROOT}/dev/toshiba c 10 181
	fi
}
