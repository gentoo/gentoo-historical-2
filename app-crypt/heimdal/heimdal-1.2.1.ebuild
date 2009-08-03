# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/heimdal/heimdal-1.2.1.ebuild,v 1.2 2009/08/03 07:53:57 mueli Exp $

EAPI=1

WANT_AUTOMAKE=latest
WANT_AUTOCONF=latest

inherit autotools libtool eutils virtualx toolchain-funcs flag-o-matic

PATCHVER=0.2
PATCH_P=${PN}-gentoo-patches-${PATCHVER}

DESCRIPTION="Kerberos 5 implementation from KTH"
HOMEPAGE="http://www.h5l.org/"
SRC_URI="http://www.h5l.org/dist/src/${P}.tar.gz
	mirror://gentoo/${PATCH_P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="afs +berkdb hdb-ldap ipv6 otp pkinit ssl threads X"

RDEPEND="ssl? ( dev-libs/openssl )
	berkdb? ( sys-libs/db )
	!berkdb? ( sys-libs/gdbm )
	>=dev-db/sqlite-3.5.7
	sys-libs/ss
	sys-libs/com_err
	afs? ( net-fs/openafs )
	hdb-ldap? ( >=net-nds/openldap-2.3.0 )
	!virtual/krb5"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=sys-devel/autoconf-2.62"
#	>=sys-devel/libtool-2.2"

PROVIDE="virtual/krb5"

GENTOODIR=${WORKDIR}/gentoo
S=${WORKDIR}/${P}

src_unpack() {
	unpack ${A}
	cd "${S}"

	EPATCH_SUFFIX="patch" epatch "${GENTOODIR}"/patches

	epatch "${FILESDIR}"/${PN}-r23238-kb5_locl_h-wind_h.patch
	epatch "${FILESDIR}"/${PN}-r23235-kb5-libwind_la.patch
	epatch "${FILESDIR}"/${PN}-kdc-sans_pkinit.patch
	epatch "${FILESDIR}"/${PN}-system_sqlite.patch
	epatch "${FILESDIR}"/${PN}-symlinked-manpages.patch
	epatch "${FILESDIR}"/${PN}-autoconf-ipv6-backport.patch

	AT_M4DIR="cf" eautoreconf

	elog ""
	elog "Heimdal is still under development in gentoo and you might"
	elog "find problems with dependencies to virtual/krb5. Nevertheless"
	elog "it's still usable. For more information visit:"
	elog ""
	elog "    http://bugs.gentoo.org/show_bug.cgi?id=185899"
	elog ""
	elog "I can also recommend to use our kerberos overlay at:"
	elog ""
	elog "    git://git.overlays.gentoo.org/proj/kerberos.git"
	elog ""
}

src_compile() {
	econf \
		$(use_with ipv6) \
		$(use_enable berkdb berkeley-db) \
		$(use_enable pkinit pk-init) \
		$(use_with ssl openssl /usr) \
		$(use_with X x) \
		$(use_enable threads pthread-support) \
		$(use_enable otp) \
		$(use_enable afs afs-support) \
		$(use_with hdb-ldap openldap /usr) \
		--disable-osfc2 \
		--enable-kcm \
		--enable-shared \
		--disable-netinfo \
		--prefix=/usr \
		--libexecdir=/usr/sbin || die "econf failed"

	local ltversion=`libtool --version |grep 'GNU libtool' |sed -e's/^.*(GNU libtool) \([0-9]\+\.[0-9]\+\(\.[0-9]\+\)\+\) .*$/\1/'`
	local ltmajor=`echo $ltversion |sed -e's/^\([0-9]\+\)\..*$/\1/'`
	local ltminor=`echo $ltversion |sed -e's/^[0-9]\+\.\([0-9]\+\)\..*$/\1/'`
	if [ $ltmajor -lt 2 ] || ( [ $ltmajor -eq 2 ] && [ $ltminor -lt 2 ] ); then
		ewarn "Using old libtool with a quick hack."
		sed -i -e's/ECHO=/echo=/' libtool
	fi

	emake || die "emake failed"
}

src_test() {
	addpredict /proc/fs/openafs/afs_ioctl
	addpredict /proc/fs/nnpfs/afs_ioctl

	if use X ; then
		KRB5_CONFIG="${S}"/krb5.conf Xmake check || die
	else
		KRB5_CONFIG="${S}"/krb5.conf make check || die
	fi
}

src_install() {
	INSTALL_CATPAGES="no" emake DESTDIR="${D}" install || die "emake install failed"

	dodoc ChangeLog README NEWS TODO

	# Begin client rename and install
	for i in {telnetd,ftpd,rshd}
	do
		mv "${D}"/usr/share/man/man8/{,k}${i}.8
		mv "${D}"/usr/sbin/{,k}${i}
	done

	for i in {rcp,rsh,telnet,ftp,su,login,pagsh}
	do
		mv "${D}"/usr/share/man/man1/{,k}${i}.1
		mv "${D}"/usr/bin/{,k}${i}
	done

	mv "${D}"/usr/share/man/man5/{,k}ftpusers.5
	mv "${D}"/usr/share/man/man5/{,k}login.access.5

	doinitd "${GENTOODIR}"/configs/heimdal-kdc
	doinitd "${GENTOODIR}"/configs/heimdal-kadmind
	doinitd "${GENTOODIR}"/configs/heimdal-kpasswdd
	doinitd "${GENTOODIR}"/configs/heimdal-kcm

	insinto /etc
	newins "${GENTOODIR}"/configs/krb5.conf krb5.conf.example

	sed -i "s:/lib:/$(get_libdir):" "${D}"/etc/krb5.conf.example || die "sed failed"

	if use hdb-ldap; then
		insinto /etc/openldap/schema
		doins "${GENTOODIR}"/configs/krb5-kdc.schema
	fi

	# default database dir
	keepdir /var/heimdal
}
