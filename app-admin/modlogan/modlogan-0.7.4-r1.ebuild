# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-admin/modlogan/modlogan-0.7.4-r1.ebuild,v 1.1 2002/04/12 22:30:07 seemant Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Logfile Analyzer"
SRC_URI="http://www.kneschke.de/projekte/modlogan/download/${P}.tar.gz
	 http://www.kneschke.de/projekte/modlogan/download/gd-1.8.1.tar.gz"

DEPEND="virtual/x11
	~media-libs/freetype-1.3
	>=media-libs/jpeg-6b
	media-libs/libpng
	>=dev-libs/libpcre-3.2
	>=net-libs/adns-1.0
	mysql? ( >=dev-db/mysql-3.23.26 )
	"
RDEPEND="${DEPEND}
    nls? ( sys-devel/gettext )
	"

src_compile() {
	cd ${S}/../gd-1.8.1
	export CFLAGS="$CFLAGS -I/usr/include/freetype" 

	./configure || die
	make || die

	cp .libs/libgd.so.0.0.0 libgd.so.0.0.0
	ln -s libgd.so.0.0.0 libgd.so

	local myconf
	use mysql	\
		 && myconf="--with-mysql=/usr"	\
		 || myconf="--without-mysql"
	
	use nls	\
		|| myconf="$myconf --disable-nls"

cd ${S}
	./configure 	\
		--host=${CHOST}	\
		--prefix=/usr \
		--enable-plugins \
		--mandir=/usr/share/man \
		--sysconfdir=/etc/modlogan	\
		--libdir=/usr/lib/modlogan	\
		--with-gd=${WORKDIR}/gd-1.8.1/ \
		--disable-check-dynamic	\
		${myconf} || die

	make || die
}

src_install() {                               
	cd ${S}/../gd-1.8.1
	into /usr
	dolib libgd.so.0.0.0
	cd ${S}
	make 	\
		prefix=${D}/usr	\
		mandir=${D}/usr/share/man	\
		sysconfdir=${D}/etc/modlogan \
		libdir=${D}/usr/lib/modlogan 	\
		install || die

	insinto /etc/modlogan
	newins ${FILESDIR}/sample.conf modlogan.conf.sample
	newins ${FILESDIR}/sample.def.conf modlogan.def.conf.sample
	doins doc/modlogan.searchengines
	insinto /etc/httpd
	newins ${FILESDIR}/modlogan.conf httpd.modlogan
	dodir /usr/local/httpd/modlogan
	preplib /usr
	dodoc AUTHORS COPYING ChangeLog README NEWS TODO
	dodoc doc/*.txt doc/*.conf doc/glosar doc/stats
	docinto html
	dodoc doc/*.html
}

pkg_postinst() {

	if [ ! -a ${ROOT}etc/modlogan/modlogan.conf ]
	then
		cd ${ROOT}/etc/modlogan
		sed -e "s:##HOST##:${HOSTNAME}:g" \
			-e "s:##HOST2##:${HOSTNAME/./\\.}:g" \
		modlogan.conf.sample > modlogan.conf
		rm modlogan.conf.sample
	fi

	if [ ! -a ${ROOT}etc/modlogan/modlogan.def.conf ]
	then
		cd ${ROOT}/etc/modlogan
		sed -e "s:##HOST##:${HOSTNAME}:g" \
			-e "s:##HOST2##:${HOSTNAME/./\\.}:g" \
		modlogan.def.conf.sample > modlogan.def.conf
		rm modlogan.def.conf.sample
	fi

}
