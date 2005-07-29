# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/partimage/partimage-0.6.4-r1.ebuild,v 1.2 2005/07/29 22:38:28 dragonheart Exp $

inherit gnuconfig eutils

DESCRIPTION="Console-based application to efficiently save raw partition data to an image file. Optional encryption/compression support."
HOMEPAGE="http://www.partimage.org/"
SRC_URI="mirror://sourceforge/partimage/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE="ssl nologin"

RDEPEND="virtual/libc
	>=sys-libs/zlib-1.1.4
	>=dev-libs/lzo-1.08
	>=dev-libs/newt-0.50.35-r1
	>=sys-libs/slang-1.4.5-r2
	app-arch/bzip2
	ssl? ( >=dev-libs/openssl-0.9.6g )"

DEPEND="${RDEPEND} sys-devel/autoconf"

PARTIMAG_GROUP_GID=91
PARTIMAG_USER_UID=91
PARTIMAG_GROUP_NAME=partimag
PARTIMAG_USER_NAME=partimag
PARTIMAG_USER_SH=/bin/false
PARTIMAG_USER_HOMEDIR=/var/log/partimage
PARTIMAG_USER_GROUPS=partimag

pkg_setup() {
	# Now add users if needed
	enewgroup ${PARTIMAG_GROUP_NAME} ${PARTIMAG_GROUP_GID}
	enewuser ${PARTIMAG_USER_NAME} ${PARTIMAG_USER_UID} ${PARTIMAG_USER_SH} ${PARTIMAG_USER_HOMEDIR} ${PARTIMAG_USER_GROUPS}
}

src_unpack() {
	unpack ${A}
	cd ${S}
	# we can do better security ourselves
	epatch ${FILESDIR}/${P}-nodumbpermchecks.diff
	epatch ${FILESDIR}/${P}-fixserverargs.diff
	# Patch Makefile.am so we can take over some of is install work
	#patch -p1 < ${FILESDIR}/${PF}-gentoo.patch || die "patch failed"
	sed '18d' -i configure.ac
	sed '1iACLOCAL_AMFLAGS = -I macros' -i Makefile.am
	for i in intl/Makefile.in po/Makefile.in.in; do
		sed 's/^mkinstalldirs =.*/mkinstalldirs = mkdir -p /g' -i ${i}
	done
	sed 's/chown partimag.root/chown partimag:root/g' -i Makefile.am
	gnuconfig_update
	automake
	aclocal
	autoconf
}

src_compile() {
	# SSL is optional
	local myconf
	myconf="--cache-file=${S}/config.cache"
	use ssl || myconf="${myconf} --disable-ssl"
	use nologin && myconf="${myconf} --disable-login"
	econf \
		${myconf} \
		--infodir=/usr/share/doc/${PF} || die "econf failed"
	cp Makefile Makefile.orig
	sed -e "s/partimag\.root/root:root/g" Makefile.orig > Makefile
	emake || die
}

src_install() {
	make \
	prefix=${D}/usr \
	sysconfdir=${D}/etc \
	mandir=${D}/usr/share/man \
	datadir=${D}/usr/share \
	infodir=${D}/usr/share/doc/${PF} \
	localedir=${D}/usr/share/locale \
	gettextsrcdir=${D}/usr/share/gettext/po \
	install || die
	keepdir /var/log/partimage
	insinto /etc/partimaged
	doins ${FILESDIR}/servercert.cnf

	# init.d / conf.d
	exeinto /etc/init.d ; newexe ${FILESDIR}/${PN}d.init ${PN}d || die
	insinto /etc/conf.d ; newins ${FILESDIR}/${PN}d.conf ${PN}d || die

	doman debian/partimage.1 debian/partimaged.8 ${FILESDIR}/partimagedusers.5 || die
}

# vars for SSL stuff
confdir="${ROOT}etc/partimaged"
privkey="${confdir}/partimaged.key"
cnf="${confdir}/servercert.cnf"
csr="${confdir}/partimaged.csr"
cert="${confdir}/partimaged.cert"

pkg_config() {
	if use ssl; then
		ewarn "Please customize /etc/partimaged/servercert.cnf before you continue!"
		ewarn "Press Ctrl-C to break now for it, or press enter to continue."
		read
		if [ ! -f ${privkey} ]; then
			einfo "Generating unencrypted private key: ${privkey}"
			openssl genrsa -out ${privkey} 1024  || die "Failed!"
		else
			einfo "Private key already exists: ${privkey}"
		fi
		if [ ! -f ${csr} ]; then
			einfo "Generating certificate request: ${csr}"
			openssl req -new -x509 -outform PEM -out ${csr} -key ${privkey} -config ${cnf} || die "Failed!"
		else
			einfo "Certificate request already exists: ${csr}"
		fi
		if [ ! -f ${cert} ]; then
			einfo "Generating self-signed certificate: ${cert}"
			openssl x509 -in ${csr} -out ${cert} -signkey ${privkey} || die "Failed!"
		else
			einfo "Self-signed certifcate already exists: ${cert}"
		fi
		einfo "Setting permissions"
		partimagesslperms || die "Failed!"
		einfo "Done"
	else
		einfo "SSL is disabled, not building certificates"
	fi
}

partimagesslperms() {
	local ret=0
	chmod 600 ${privkey} 2>/dev/null
	ret=$((${ret}+$?))
	chown partimag:root ${privkey} 2>/dev/null
	ret=$((${ret}+$?))
	chmod 644 ${cert} ${csr} 2>/dev/null
	ret=$((${ret}+$?))
	chown root:root ${cert} ${csr} 2>/dev/null
	ret=$((${ret}+$?))
	return $ret
}

pkg_postinst() {
	if use ssl; then
		einfo "To create the required SSL certificates, please do:"
		einfo "ebuild /var/db/pkg/${CATEGORY}/${PF}/${PF}.ebuild config"
		# force a permmissions fixup
		partimagesslperms
		return 0
	fi
}
