# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/vdradmin-am/vdradmin-am-3.5.2.ebuild,v 1.3 2007/01/06 14:53:38 zzam Exp $

inherit eutils

DESCRIPTION="WWW Admin for the Video Disk Recorder"
HOMEPAGE="http://andreas.vdr-developer.org/"
SRC_URI="http://andreas.vdr-developer.org/download/${P}.tar.bz2"

KEYWORDS="~x86 ~amd64"
SLOT="0"
LICENSE="GPL-2"
IUSE="unicode"

RDEPEND="dev-lang/perl
	dev-perl/Template-Toolkit
	>=dev-perl/Compress-Zlib-1.2.2
	media-video/vdr
	dev-perl/Compress-Zlib
	dev-perl/Locale-gettext
	dev-perl/Authen-SASL
	dev-perl/Digest-HMAC
	unicode? ( sys-devel/gettext )"

ETC_DIR="/etc/vdradmin"
LIB_DIR="/usr/share/vdradmin"
VDRADMIN_USER="vdradmin"
VDRADMIN_GROUP="vdradmin"
TMP_DIR=/var/tmp/vdradmin

pkg_setup() {
	enewuser ${VDRADMIN_USER} -1 /bin/bash ${TMP_DIR}
}

src_unpack() {

	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PN}-config-autoflush.diff
	sed -i vdradmind.pl \
		-e "/COMPILE_DIR/s-/tmp-${TMP_DIR}-" \
		-e "s-/var/run/vdradmind.pid-/var/tmp/vdradmin/vdradmind.pid-"
}


src_compile() {

	if ! use unicode; then
		einfo "no need to compile"
	else
		einfo "additionally generating utf8 locales"
		${S}/make.sh utf8add || die
		${S}/make.sh po || die
	fi
}

src_install() {

	newinitd ${FILESDIR}/vdradmin-2 vdradmin
	newconfd ${FILESDIR}/confd-2 vdradmin

	dobin vdradmind.pl

	insinto ${LIB_DIR}/template
	doins -r ${S}/template/*

	insinto ${LIB_DIR}/lib
	doins -r ${S}/lib/*

	insinto /usr/share/locale/
	doins -r ${S}/locale/*

	exeinto ${LIB_DIR}
	doexe autotimer2searchtimer.pl

	dodoc HISTORY INSTALL CREDITS README* REQUIREMENTS FAQ
	docinto contrib
	dodoc ${S}/contrib/*

	diropts "-m755 -o ${VDRADMIN_USER} -g ${VDRADMIN_GROUP}"
	keepdir "${ETC_DIR}"
	keepdir "${TMP_DIR}"

	dosed "s:FILES_IN_SYSTEM    = 0;:FILES_IN_SYSTEM    = 1;:g" /usr/bin/vdradmind.pl
}

pkg_preinst() {
	if [[ -f ${ROOT}${ETC_DIR}/vdradmind.conf ]]; then
		cp ${ROOT}${ETC_DIR}/vdradmind.conf ${D}${ETC_DIR}/vdradmind.conf
	else
		elog "Creating a new config-file."
		echo

		cat <<-EOF > ${D}${ETC_DIR}/vdradmind.conf
			VDRCONFDIR = /etc/vdr
			VIDEODIR = /var/vdr/video
			EPG_FILENAME = /var/vdr/video/epg.data
			EPGIMAGES = /var/vdr/video/epgimages
			PASSWORD = gentoo-vdr
			USERNAME = gentoo-vdr
		EOF
		# feed it with newlines
		yes "" \
		  | ${D}/usr/bin/vdradmind.pl --cfgdir ${D}${ETC_DIR} --config \
		  |sed -e 's/: /: \n/g'

		elog
		elog "Created default user/password: gentoo-vdr/gentoo-vdr"
		elog
		elog "you can run \"emerge --config vdradmin-am\" if"
		elog "the default-values for vdr does not match your"
		elog "installation or change it in Setup-Menu of Web-Interface."
		elog
	fi
	chown ${VDRADMIN_USER}:${VDRADMIN_GROUP} ${D}${ETC_DIR}/vdradmind.conf
}

pkg_postinst() {
	if [[ -d ${ROOT}${ETC_DIR} ]]; then
		local owner=$(stat ${ROOT}${ETC_DIR} -c "%U")
		if [[ ${owner} != vdradmin ]]; then
			elog "Changing ownership of ${ETC_DIR}."
			chown -R ${VDRADMIN_USER}:${VDRADMIN_GROUP} ${ROOT}${ETC_DIR}
		fi
	fi

	if [[ -d ${ROOT}/tmp/usr/share/vdradmin ]]; then
		ewarn "You have a leftover directory of vdradmin."
		ewarn "You can safely remove it with:"
		ewarn "# rm -rf /tmp/usr/share/vdradmin/template"
		ewarn "# rmdir -p /tmp/usr/share/vdradmin"
	fi

	local DEST=/etc/vdr/plugins/epgsearch/epgsearch.conf
	local SOURCE=${ETC_DIR}/vdradmind.at
	if [[ -s ${ROOT}${SOURCE} ]]; then
		ewarn "If you used the autotimer of vdradmin,"
		ewarn "it is a good idea to convert them now"
		ewarn "to use with epgsearch."
		ewarn
		if [[ ! -d ${ROOT}/etc/vdr/plugins/epgsearch ]]; then
			ewarn "# install -d -o vdr -g vdr /etc/vdr/plugins/epgsearch"
		fi

		local SIZE=0

		[[ -e ${DEST} ]] && SIZE=$(grep '^[^#]' ${ROOT}${DEST}|wc -l)

		ewarn "If vdr is running with epgsearch-Plugin loaded you can use (recommended):"
		local BASE_CMD="${LIB_DIR}/autotimer2searchtimer.pl -i ${SOURCE}"
		ewarn "# ${BASE_CMD} -s"

		ewarn
		ewarn "Else you can use this:"
		if [[ ${SIZE} == 0 ]]; then
			ewarn "# ${BASE_CMD} -o ${DEST}"
		else
			ewarn "You already have some timers defined!."
			ewarn "# ${BASE_CMD} -o ${DEST}.new"
			ewarn
			ewarn "You need to merge epgsearch.conf and epgsearch.conf.new on your own."
			ewarn
		fi
		ewarn "# chown vdr:vdr ${DEST}"
		ewarn
		ewarn "If you are sure that epgsearch has got all your timer,"
		ewarn "then you can delete vdradmin-autotimers."
		ewarn "# rm ${SOURCE}"
	fi
}

pkg_config() {
	/usr/bin/vdradmind.pl -c
	chown ${VDRADMIN_USER}:${VDRADMIN_GROUP} ${ROOT}${ETC_DIR}/vdradmind.conf
}

