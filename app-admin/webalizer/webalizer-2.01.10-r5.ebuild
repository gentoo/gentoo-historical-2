# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/webalizer/webalizer-2.01.10-r5.ebuild,v 1.4 2004/05/31 19:21:33 vapier Exp $

inherit eutils

MY_PV=${PV/.10/-10}
MY_P=${PN}-${MY_PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Webserver log file analyzer"
HOMEPAGE="http://www.mrunix.net/webalizer/"
SRC_URI="ftp://ftp.mrunix.net/pub/webalizer/${MY_P}-src.tar.bz2
	geoip? ( http://sysd.org/proj/geolizer_${MY_PV}-patch.20040216.tar.bz2 )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~hppa ~amd64"
IUSE="geoip"

DEPEND="=sys-libs/db-1*
	>=sys-libs/zlib-1.1.4
	>=media-libs/libpng-1.2
	>=media-libs/libgd-1.8.3
	geoip? ( dev-libs/geoip )"

src_unpack() {
	unpack ${A} ; cd ${S}
	# fix --enable-dns; our db1 headers are in /usr/include/db1
#	mv dns_resolv.c dns_resolv.c.orig
#	sed -e 's%^\(#include \)\(<db.h>\)\(.*\)%\1<db1/db.h>\3%' \
#		dns_resolv.c.orig > dns_resolv.c
	sed -i -e "s,db_185.h,db.h," configure

	if use geoip ; then
		( cd ${WORKDIR} && unpack geolizer_${MY_PV}-patch.20040216.tar.bz2 )
		epatch ${WORKDIR}/geolizer_${MY_PV}-patch/geolizer.patch || die
	fi
}

src_compile() {
	myconf="`use_enable geoip`"
	econf ${myconf} --enable-dns --with-db=/usr/include/db1/ || die
	make || die
}

src_install() {
	into /usr
	dobin webalizer
	dosym webalizer /usr/bin/webazolver
	doman webalizer.1

	insinto /etc
	newins ${FILESDIR}/${PV}/webalizer.conf webalizer.conf

	if [ "`use apache2`" ]; then
		# patch for apache2
		sed -i -e "s/apache/apache2/g" ${D}/etc/webalizer.conf
		insinto /etc/apache2/conf
	else
		insinto /etc/apache/conf
	fi

	doins ${FILESDIR}/${PV}/webalizer.conf

	use apache2 || insinto /etc/apache/conf/addon-modules
	use apache2 || newins ${FILESDIR}/${PV}/apache.webalizer webalizer.conf

	use apache2 && insinto /etc/apache2/conf/modules.d
	use apache2 && newins ${FILESDIR}/${PV}/apache.webalizer 55_webalizer.conf

	dodoc README* CHANGES Copyright sample.conf
	dodir /var/www/webalizer
}

pkg_postinst(){
	if [ -n "`use apache2`" ]; then
	einfo "to update your apache.conf just type"
	einfo "echo \"Include  conf/addon-modules/webalizer.conf\" \
		>> /etc/apache/conf/apache.conf"
	fi
	einfo
	einfo "Just type webalizer to generate your stats."
	einfo "You can also use cron to generate them e.g. every day."
	einfo "They can be accessed via http://localhost/webalizer"
	einfo
}
