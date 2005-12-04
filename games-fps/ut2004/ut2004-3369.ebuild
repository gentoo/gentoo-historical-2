inherit eutils games

MY_P="${PN}-lnxpatch${PV}.tar.bz2"
DESCRIPTION="Unreal Tournament 2004 - Editor's Choice Edition"
HOMEPAGE="http://www.unrealtournament2004.com/"
SRC_URI="mirror://3dgamers/unrealtourn2k4/${MY_P}
	http://speculum.twistedgamer.com/pub/0day.icculus.org/${PN}/${MY_P}"

LICENSE="ut2003"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="nostrip nomirror"
IUSE="opengl dedicated"

RDEPEND="games-fps/ut2004-data
	games-fps/ut2004-bonuspack-ece
	opengl? ( virtual/opengl )
	dedicated? ( app-misc/screen )
	amd64? ( sys-libs/libstdc++-v3 )"

S=${WORKDIR}/UT2004-Patch

dir=${GAMES_PREFIX_OPT}/${PN}
Ddir=${D}/${dir}

pkg_setup() {
	check_license ut2003
	games_pkg_setup
}

src_install() {
	# Installing patch files
	for p in {Animations,Help,Speech,System,Textures,Web}
	do
		dodir ${dir}/${p}
		cp -r ${S}/${p}/* ${Ddir}/${p} \
			|| die "copying ${p} from patch"
	done

	use amd64 && rm ${Ddir}/System/u{cc,t2004}-bin \
		&& mv ${Ddir}/System/ucc-bin-linux-amd64 ${Ddir}/System/ucc-bin \
		&& mv ${Ddir}/System/ut2004-bin-linux-amd64 ${Ddir}/System/ut2004-bin \
		&& chmod ug+x ${Ddir}/System/ucc-bin ${Ddir}/System/ut2004-bin
	use x86 && rm ${Ddir}/System/ucc-bin-linux-amd64 \
		${Ddir}/System/ut2004-bin-linux-amd64

	# creating .manifest files
	insinto ${dir}/.manifest
	doins ${FILESDIR}/${PN}.xml

	# creating .loki/installed links
	mkdir -p ${D}/root/.loki/installed
	dosym ${dir}/.manifest/${PN}.xml ${ROOT}/root/.loki/installed/${PN}.xml

	games_make_wrapper ut2004 ./ut2004 "${dir}" "${dir}"

	prepgamesdirs
	make_desktop_entry ut2004 "Unreal Tournament 2004" ut2004.xpm
}

pkg_postinst() {
	games_pkg_postinst

	# here is where we check for the existence of a cdkey...
	# if we don't find one, we ask the user for it
	if [ -f ${dir}/System/cdkey ]; then
		einfo "A cdkey file is already present in ${dir}/System"
	else
		ewarn "You MUST run this before playing the game:"
		ewarn "emerge --config =${CATEGORY}/${PF}"
		ewarn "That way you can [re]enter your cdkey."
	fi
	echo
	einfo "To play the game run:"
	einfo " ut2004"
	echo
}

pkg_postrm() {
	ewarn "This package leaves a cdkey file in ${dir}/System that you need"
	ewarn "to remove to completely get rid of this game's files."
}

pkg_config() {
	ewarn "Your CD key is NOT checked for validity here."
	ewarn "  Make sure you type it in correctly."
	eerror "If you CTRL+C out of this, the game will not run!"
	echo
	einfo "CD key format is: XXXXX-XXXXX-XXXXX-XXXXX"
	while true ; do
		einfo "Please enter your CD key:"
		read CDKEY1
		einfo "Please re-enter your CD key:"
		read CDKEY2
		if [ "$CDKEY1" == "" ] ; then
			echo "You entered a blank CD key.  Try again."
		else
			if [ "$CDKEY1" == "$CDKEY2" ] ; then
				echo "$CDKEY1" | tr a-z A-Z > ${dir}/System/cdkey
				einfo "Thank you!"
				break
			else
				eerror "Your CD key entries do not match.  Try again."
			fi
		fi
	done
}
