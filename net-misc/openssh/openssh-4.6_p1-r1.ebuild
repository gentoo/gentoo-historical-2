# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/openssh/openssh-4.6_p1-r1.ebuild,v 1.2 2007/04/01 23:04:57 vapier Exp $

inherit eutils flag-o-matic ccc multilib autotools pam

# Make it more portable between straight releases
# and _p? releases.
PARCH=${P/_/}

X509_PATCH="${PARCH}+x509-5.5.2.diff.gz"
SECURID_PATCH="" #${PARCH/4.6/4.5}+SecurID_v1.3.2.patch"
LDAP_PATCH="" #${PARCH/-4.5p1/-lpk-4.5p1}-0.3.8.patch"
HPN_PATCH="${PARCH}-hpn12v16.diff.gz"

DESCRIPTION="Port of OpenBSD's free SSH release"
HOMEPAGE="http://www.openssh.com/"
SRC_URI="mirror://openbsd/OpenSSH/portable/${PARCH}.tar.gz
	X509? ( http://roumenpetrov.info/openssh/x509-5.5.2/${X509_PATCH} )
	hpn? ( http://www.psc.edu/networking/projects/hpn-ssh/${HPN_PATCH} )"
#	smartcard? ( http://omniti.com/~jesus/projects/${SECURID_PATCH} )
#	ldap? ( http://dev.inversepath.com/openssh-lpk/${LDAP_PATCH} )

LICENSE="as-is"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE="static pam tcpd kerberos skey selinux chroot X509 ldap smartcard hpn libedit X"

RDEPEND="pam? ( virtual/pam )
	kerberos? ( virtual/krb5 )
	selinux? ( >=sys-libs/libselinux-1.28 )
	skey? ( >=app-admin/skey-1.1.5-r1 )
	ldap? ( net-nds/openldap )
	libedit? ( dev-libs/libedit )
	>=dev-libs/openssl-0.9.6d
	>=sys-libs/zlib-1.2.3
	smartcard? ( dev-libs/opensc )
	tcpd? ( >=sys-apps/tcp-wrappers-7.6 )
	X? ( x11-apps/xauth )
	userland_GNU? ( sys-apps/shadow )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	virtual/os-headers
	sys-devel/autoconf"
PROVIDE="virtual/ssh"

S=${WORKDIR}/${PARCH}

pkg_setup() {
	# this sucks, but i'd rather have people unable to `emerge -u openssh`
	# than not be able to log in to their server any more
	maybe_fail() { [[ -z ${!2} ]] && use ${1} && echo ${1} ; }
	local fail="
		$(maybe_fail X509 X509_PATCH)
		$(maybe_fail smartcard SECURID_PATCH)
		$(maybe_fail ldap LDAP_PATCH)
	"
	fail=$(echo ${fail})
	if [[ -n ${fail} ]] ; then
		eerror "Sorry, but this version does not yet support features"
		eerror "that you requested:	 ${fail}"
		eerror "Please mask ${PF} for now and check back later:"
		eerror " # echo '=${CATEGORY}/${PF}' >> /etc/portage/package.mask"
		die "booooo"
	fi
}

src_unpack() {
	unpack ${PARCH}.tar.gz
	cd "${S}"

	sed -i \
		-e '/_PATH_XAUTH/s:/usr/X11R6/bin/xauth:/usr/bin/xauth:' \
		pathnames.h || die

	epatch "${FILESDIR}"/${P}-include-string-header.patch
	epatch "${FILESDIR}"/${P}-ChallengeResponseAuthentication.patch #170670
	use X509 && epatch "${DISTDIR}"/${X509_PATCH} "${FILESDIR}"/${PN}-4.4_p1-x509-hpn-glue.patch
	use chroot && epatch "${FILESDIR}"/openssh-4.3_p1-chroot.patch
	use smartcard && epatch "${FILESDIR}"/openssh-3.9_p1-opensc.patch
	if ! use X509 ; then
		if [[ -n ${SECURID_PATCH} ]] && use smartcard ; then
			epatch "${DISTDIR}"/${SECURID_PATCH} \
				"${FILESDIR}"/${PN}-4.3_p2-securid-updates.patch \
				"${FILESDIR}"/${PN}-4.3_p2-securid-hpn-glue.patch
			use ldap && epatch "${FILESDIR}"/openssh-4.0_p1-smartcard-ldap-happy.patch
		fi
		if [[ -n ${LDAP_PATCH} ]] && use ldap ; then
			epatch "${DISTDIR}"/${LDAP_PATCH} "${FILESDIR}"/${PN}-4.4_p1-ldap-hpn-glue.patch
		fi
	elif [[ -n ${SECURID_PATCH} ]] && use smartcard || use ldap ; then
		ewarn "Sorry, X509 and smartcard/ldap don't get along, disabling smartcard/ldap"
	fi
	[[ -n ${HPN_PATCH} ]] && use hpn && epatch "${DISTDIR}"/${HPN_PATCH}

	sed -i "s:-lcrypto:$(pkg-config --libs openssl):" configure{,.ac} || die

	eautoreconf
}

src_compile() {
	addwrite /dev/ptmx
	addpredict /etc/skey/skeykeys #skey configure code triggers this

	local myconf=""
	if use static ; then
		append-ldflags -static
		use pam && ewarn "Disabling pam support becuse of static flag"
		myconf="${myconf} --without-pam"
	else
		myconf="${myconf} $(use_with pam)"
	fi

	econf \
		--with-ldflags="${LDFLAGS}" \
		--disable-strip \
		--sysconfdir=/etc/ssh \
		--libexecdir=/usr/$(get_libdir)/misc \
		--datadir=/usr/share/openssh \
		--disable-suid-ssh \
		--with-privsep-path=/var/empty \
		--with-privsep-user=sshd \
		--with-md5-passwords \
		$(use_with ldap) \
		$(use_with libedit) \
		$(use_with kerberos kerberos5 /usr) \
		$(use_with tcpd tcp-wrappers) \
		$(use_with selinux) \
		$(use_with skey) \
		$(use_with smartcard opensc) \
		${myconf} \
		|| die "bad configure"
	emake || die "compile problem"
}

src_install() {
	emake install-nokeys DESTDIR="${D}" || die
	fperms 600 /etc/ssh/sshd_config
	dobin contrib/ssh-copy-id
	newinitd "${FILESDIR}"/sshd.rc6 sshd
	newconfd "${FILESDIR}"/sshd.confd sshd
	keepdir /var/empty

	newpamd "${FILESDIR}"/sshd.pam_include sshd
	dosed "/^#Protocol /s:.*:Protocol 2:" /etc/ssh/sshd_config
	use pam \
		&& dosed "/^#UsePAM /s:.*:UsePAM yes:" /etc/ssh/sshd_config \
		&& dosed "/^#PasswordAuthentication /s:.*:PasswordAuthentication no:" /etc/ssh/sshd_config

	doman contrib/ssh-copy-id.1
	dodoc ChangeLog CREDITS OVERVIEW README* TODO sshd_config

	diropts -m 0700
	dodir /etc/skel/.ssh
}

pkg_postinst() {
	enewgroup sshd 22
	enewuser sshd 22 -1 /var/empty sshd

	ewarn "Remember to merge your config files in /etc/ssh/ and then"
	ewarn "restart sshd: '/etc/init.d/sshd restart'."
	if use pam ; then
		echo
		ewarn "Please be aware users need a valid shell in /etc/passwd"
		ewarn "in order to be allowed to login."
	fi
}
