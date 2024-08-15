local PANEL = {}

surface.CreateFont("micro_scoreboard_player_panel_16",{
	font = "Better VCR",
	size = 11,
	weight = 550
})

--Icons
svg.Generate("MS_Clock", 14, 14, [[<!-- icon666.com - MILLIONS vector ICONS FREE --><svg version="1.1" id="Capa_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 426.667 426.667" style="enable-background:new 0 0 426.667 426.667;" xml:space="preserve"><g><g><path d="M213.227,0C95.36,0,0,95.467,0,213.333s95.36,213.333,213.227,213.333s213.44-95.467,213.44-213.333S331.093,0,213.227,0z M213.333,384c-94.293,0-170.667-76.373-170.667-170.667S119.04,42.667,213.333,42.667S384,119.04,384,213.333 S307.627,384,213.333,384z"/></g></g><g><g><polygon points="224,218.667 224,106.667 192,106.667 192,234.667 303.893,301.867 320,275.627 "/></g></g></svg>]])
local gradient_up = Material("vgui/gradient-r")
local PlayerVolumeColor = Color(159, 189, 255)

svg.Generate("MS_Badge", 16, 16, [[<!-- icon666.com - MILLIONS vector ICONS FREE --><svg id="Capa_1" enable-background="new 0 0 509.385 509.385" viewBox="0 0 509.385 509.385" xmlns="http://www.w3.org/2000/svg"><g><path d="m443.692 189c0-20.973-19.938-35.404-22.406-44.636-2.682-10.04 7.477-31.958-2.9-49.894-10.373-17.929-34.75-20.381-41.768-27.396-7.01-7.013-9.471-31.398-27.396-41.769-17.967-10.395-39.834-.207-49.894-2.9-9.241-2.47-23.652-22.405-44.636-22.405-20.973 0-35.404 19.938-44.636 22.406-10.039 2.682-31.961-7.477-49.894 2.9-17.929 10.373-20.381 34.75-27.396 41.768-7.013 7.01-31.397 9.471-41.769 27.396-10.363 17.913-.225 39.878-2.9 49.894-2.471 9.241-22.406 23.652-22.406 44.636 0 20.973 19.938 35.404 22.406 44.636 2.682 10.04-7.477 31.958 2.9 49.894 10.373 17.929 34.75 20.381 41.768 27.396 5.007 5.009 8.386 21.193 16.926 32.372v166.088l105-43.167 105 43.167v-166.09c8.445-11.054 11.922-27.363 16.925-32.369 7.013-7.01 31.398-9.471 41.769-27.397 10.363-17.913.225-39.878 2.9-49.894 2.472-9.241 22.407-23.653 22.407-44.636zm-264 168.468c11.422.036 24.352-3.482 30.364-1.874 6.501 1.738 16.912 13.392 29.636 19.036v65.319l-60 24.666zm90 82.481v-65.319c12.489-5.54 23.27-17.334 29.636-19.036 6.02-1.612 18.888 1.91 30.364 1.874v107.147zm135.61-236.764c-4.981 6.486-10.628 13.838-12.998 22.705-2.446 9.151-1.232 18.542-.162 26.827.725 5.612 1.718 13.298.277 15.789-1.518 2.623-8.469 5.504-14.054 7.818-7.662 3.175-16.347 6.773-22.961 13.389-6.615 6.615-10.214 15.299-13.389 22.961-2.314 5.585-5.195 12.535-7.817 14.053-2.489 1.441-10.176.447-15.789-.277-8.284-1.07-17.677-2.284-26.827.162-8.867 2.37-16.219 8.017-22.705 12.998-4.867 3.738-10.924 8.391-14.185 8.391s-9.317-4.652-14.185-8.391c-11.802-9.064-19.822-14.426-34.55-14.426-11.293 0-26.752 3.871-30.771 1.543-2.623-1.518-5.504-8.469-7.818-14.054-3.175-7.662-6.773-16.347-13.389-22.961-6.615-6.615-15.299-10.214-22.961-13.389-5.585-2.314-12.535-5.195-14.053-7.817-1.44-2.491-.447-10.177.277-15.789 1.07-8.285 2.284-17.676-.162-26.827-2.37-8.867-8.017-16.219-12.998-22.705-3.738-4.867-8.391-10.924-8.391-14.185s4.652-9.317 8.391-14.185c4.981-6.486 10.628-13.838 12.998-22.705 2.446-9.151 1.232-18.542.162-26.827-.725-5.612-1.718-13.298-.277-15.789 1.518-2.623 8.469-5.504 14.054-7.818 7.662-3.175 16.347-6.773 22.961-13.389 6.615-6.615 10.214-15.299 13.389-22.961 2.314-5.585 5.195-12.535 7.817-14.053 2.49-1.44 10.176-.447 15.789.277 8.283 1.069 17.675 2.282 26.827-.162 8.867-2.37 16.219-8.017 22.705-12.998 4.868-3.738 10.925-8.39 14.185-8.39s9.317 4.652 14.185 8.391c6.486 4.982 13.838 10.628 22.705 12.998 9.152 2.446 18.542 1.232 26.827.162 5.613-.725 13.3-1.719 15.789-.277 2.623 1.518 5.504 8.469 7.818 14.054 3.175 7.662 6.773 16.347 13.389 22.961 6.615 6.615 15.299 10.214 22.961 13.389 5.585 2.314 12.535 5.195 14.053 7.817 1.44 2.491.447 10.177-.277 15.789-1.07 8.285-2.284 17.676.162 26.827 2.37 8.867 8.017 16.219 12.998 22.705 3.738 4.867 8.391 10.924 8.391 14.185s-4.653 9.316-8.391 14.184z"/><path d="m254.692 84c-57.897 0-105 47.102-105 105s47.103 105 105 105 105-47.102 105-105-47.102-105-105-105zm0 180c-41.355 0-75-33.645-75-75s33.645-75 75-75 75 33.645 75 75-33.644 75-75 75z"/></g></svg>]])
svg.Generate("MS_Broom", 16, 16, [[<!-- icon666.com - MILLIONS vector ICONS FREE --><svg version="1.1" id="Capa_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 512.011 512.011" style="enable-background:new 0 0 512.011 512.011;" xml:space="preserve"><g><g><path d="M366.95,290.122H127.993c-4.711,0-8.534,3.823-8.534,8.534v51.205c0,4.711,3.823,8.534,8.534,8.534H366.95 c4.711,0,8.534-3.815,8.534-8.534v-51.205C375.484,293.945,371.661,290.122,366.95,290.122z M358.416,341.327H136.527V307.19 h221.889V341.327z"/></g></g><g><g><path d="M384.018,238.917H110.924c-4.711,0-8.534,3.823-8.534,8.534v51.205c0,4.711,3.823,8.534,8.534,8.534h273.094 c4.711,0,8.534-3.815,8.534-8.534v-51.205C392.552,242.74,388.729,238.917,384.018,238.917z M375.484,290.122H119.458v-34.137 h256.026V290.122z"/></g></g><g><g><path d="M179.198,383.998c-4.711,0-8.534,3.823-8.534,8.534v101.335c-14.704-3.806-25.603-17.188-25.603-33.061V349.861 c0-4.711-3.823-8.534-8.534-8.534c-4.711,0-8.534,3.823-8.534,8.534v110.944c0,28.24,22.966,51.205,51.205,51.205 c4.711,0,8.534-3.815,8.534-8.534V392.532C187.732,387.821,183.909,383.998,179.198,383.998z"/></g></g><g><g><path d="M247.471,42.63c-18.826,0-34.137,15.31-34.137,34.137s15.31,34.137,34.137,34.137s34.137-15.31,34.137-34.137 S266.298,42.63,247.471,42.63z M247.471,93.835c-9.413,0-17.068-7.655-17.068-17.068s7.655-17.068,17.068-17.068 c9.413,0,17.068,7.655,17.068,17.068S256.884,93.835,247.471,93.835z"/></g></g><g><g><path d="M366.95,238.917c-37.644,0-68.273-30.629-68.273-68.273c0-13.16,1.715-25.961,5.086-38.062 c7.032-25.21,8.193-50.019,3.439-73.77c-0.068-0.333-0.145-0.657-0.256-0.981c0,0-1.707-5.206-2.697-7.877 c-5.359-20.013-17.572-36.134-33.394-44.224c-14.32-7.672-32.618-7.578-46.622-0.077c-15.976,8.167-28.18,24.297-33.539,44.301 c-0.99,2.671-2.697,7.877-2.697,7.877c-0.102,0.324-0.188,0.649-0.256,0.981c-4.745,23.751-3.593,48.568,3.439,73.77 c3.371,12.102,5.086,24.903,5.086,38.062c0,37.644-30.629,68.273-68.273,68.273c-4.711,0-8.534,3.823-8.534,8.534 s3.823,8.534,8.534,8.534H366.95c4.711,0,8.534-3.823,8.534-8.534S371.661,238.917,366.95,238.917z M179.146,238.917 c20.747-15.583,34.188-40.384,34.188-68.273c0-14.704-1.92-29.059-5.701-42.637c-6.264-22.419-7.348-44.395-3.243-65.338 c0.444-1.357,1.724-5.214,2.424-7.049c0.111-0.29,0.205-0.58,0.282-0.879c4.071-15.515,13.151-27.856,25.065-33.949 c9.422-5.052,21.062-5.129,30.791,0.077c11.76,6.008,20.841,18.357,24.911,33.864c0.077,0.299,0.171,0.589,0.282,0.879 c0.7,1.835,1.98,5.692,2.424,7.049c4.105,20.934,3.013,42.918-3.243,65.338c-3.789,13.586-5.709,27.932-5.709,42.645 c0,27.89,13.441,52.69,34.188,68.273H179.146z"/></g></g><g><g><path d="M256.005,494.942c-7.604,0-25.603-19.876-25.603-51.205v-93.876c0-4.711-3.823-8.534-8.534-8.534h-42.671 c-4.711,0-8.534,3.823-8.534,8.534v93.876c0,33.096,29.912,68.274,85.342,68.274c4.711,0,8.534-3.823,8.534-8.534 C264.54,498.766,260.716,494.942,256.005,494.942z M187.732,443.737v-85.342h25.603v85.342c0,18.255,5.163,34.563,12.707,46.656 C200.789,481.885,187.732,462.726,187.732,443.737z"/></g></g><g><g><path d="M315.745,435.203c-4.711,0-8.534,3.823-8.534,8.534v17.068c0,4.711,3.823,8.534,8.534,8.534s8.534-3.815,8.534-8.534 v-17.068C324.279,439.026,320.456,435.203,315.745,435.203z"/></g></g><g><g><path d="M358.416,494.942h-102.41c-8.355,0-25.603-12.52-25.603-51.205v-85.342h76.808v34.137c0,4.711,3.823,8.534,8.534,8.534 s8.534-3.823,8.534-8.534v-42.671c0-4.711-3.823-8.534-8.534-8.534h-93.876c-4.711,0-8.534,3.823-8.534,8.534v93.876 c0,50.096,25.517,68.274,42.671,68.274h102.41c4.711,0,8.534-3.823,8.534-8.534C366.95,498.766,363.126,494.942,358.416,494.942z" /></g></g><g><g><path d="M273.074,341.327c-4.711,0-8.534,3.823-8.534,8.534v34.137c0,4.711,3.823,8.534,8.534,8.534s8.534-3.815,8.534-8.534 v-34.137C281.608,345.15,277.785,341.327,273.074,341.327z"/></g></g><g><g><path d="M273.074,418.135c-4.711,0-8.534,3.823-8.534,8.534v76.808c0,4.711,3.823,8.534,8.534,8.534s8.534-3.815,8.534-8.534 v-76.808C281.608,421.958,277.785,418.135,273.074,418.135z"/></g></g><g><g><path d="M401.087,494.942c-18.826,0-34.137-15.31-34.137-34.137V349.861c0-4.711-3.823-8.534-8.534-8.534h-59.739 c-4.711,0-8.534,3.823-8.534,8.534c0,4.711,3.823,8.534,8.534,8.534h51.205v102.41c0,13.1,4.95,25.073,13.074,34.137h-4.54 c-18.826,0-34.137-15.31-34.137-34.137c0-4.711-3.823-8.534-8.534-8.534s-8.534,3.823-8.534,8.534 c0,28.24,22.965,51.205,51.205,51.205h42.671c4.711,0,8.534-3.823,8.534-8.534C409.621,498.766,405.797,494.942,401.087,494.942z" /></g></g></svg>]])
local RankImage = {
	["superadmin"] = {
		Icon = "MS_Badge",
		Tooltip = "Supreme Overseer of Janitorial Staff"
	},
	["admin"] = {
		Icon = "MS_Broom",
		Tooltip = "Janitor"
	}
}

--Right Click Menu
svg.Generate("micro_scoreboard_dmenu_copy", 16, 16, [[<!-- icon666.com - MILLIONS vector ICONS FREE --><svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 472 472" style="enable-background:new 0 0 472 472;" xml:space="preserve"><path d="M321,118.787V0H51v362h100v110h270V218.787L321,118.787z M321,161.213L369.787,210H321V161.213z M81,332V30h210v80H151v222 H81z M181,442V140h110v100h100v202H181z"/></svg>]])
svg.Generate("micro_scoreboard_dmenu_copy_name", 16, 16, [[<!-- icon666.com - MILLIONS vector ICONS FREE --><svg version="1.1" id="Capa_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 512 512" style="enable-background:new 0 0 512 512;" xml:space="preserve"><g><g><circle cx="256" cy="137" r="15"/></g></g><g><g><circle cx="377" cy="377" r="15"/></g></g><g><g><path d="M497,422h-15V75c0-8.284-6.716-15-15-15h-45V15c0-8.284-6.716-15-15-15H15C6.716,0,0,6.716,0,15v422 c0,8.284,6.716,15,15,15h45c0,33.084,26.916,60,60,60h332c33.084,0,60-26.916,60-60v-15C512,428.716,505.284,422,497,422z M75,60 c-8.284,0-15,6.716-15,15c0,7.137,0,339.52,0,347H30V30h362v30H75z M159.161,423.179C153.778,425.456,150,430.787,150,437v15 c0,16.542-13.458,30-30,30s-30-13.458-30-30c0-2.854,0-351.918,0-362h362v332H165C162.929,422,160.956,422.42,159.161,423.179z M452,482H171.928c5.123-8.833,8.072-19.175,8.072-30.1h302C482,468.442,468.542,482,452,482z"/></g></g><g><g><path d="M196,122h-61c-8.284,0-15,6.716-15,15s6.716,15,15,15h61c8.284,0,15-6.716,15-15S204.284,122,196,122z"/></g></g><g><g><path d="M407,182H135c-8.284,0-15,6.716-15,15s6.716,15,15,15h272c8.284,0,15-6.716,15-15S415.284,182,407,182z"/></g></g><g><g><path d="M407,242H135c-8.284,0-15,6.716-15,15s6.716,15,15,15h272c8.284,0,15-6.716,15-15S415.284,242,407,242z"/></g></g><g><g><path d="M407,302H135c-8.284,0-15,6.716-15,15s6.716,15,15,15h272c8.284,0,15-6.716,15-15S415.284,302,407,302z"/></g></g><g><g><path d="M317,362H135c-8.284,0-15,6.716-15,15s6.716,15,15,15h182c8.284,0,15-6.716,15-15S325.284,362,317,362z"/></g></g></svg>]])
svg.Generate("micro_scoreboard_dmenu_copy_button_profile_url", 16, 16, [[<!-- icon666.com - MILLIONS vector ICONS FREE --><svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 512 512" style="enable-background:new 0 0 512 512;" xml:space="preserve"><g transform="translate(1 1)"><path d="M417.133,502.467H92.867c-46.933,0-85.333-38.4-85.333-85.333V92.867c0-46.933,38.4-85.333,85.333-85.333h324.267 c46.933,0,85.333,38.4,85.333,85.333v324.267C502.467,464.067,464.067,502.467,417.133,502.467"/><path d="M417.133,511H92.867C40.813,511-1,469.187-1,417.133V92.867C-1,40.813,40.813-1,92.867-1h324.267 C469.187-1,511,40.813,511,92.867v324.267C511,469.187,469.187,511,417.133,511z M92.867,16.067c-42.667,0-76.8,34.133-76.8,76.8 v324.267c0,42.667,34.133,76.8,76.8,76.8h324.267c42.667,0,76.8-34.133,76.8-76.8V92.867c0-42.667-34.133-76.8-76.8-76.8H92.867z" /><path style="fill:#FFFFFF;" d="M365.933,289.133C304.493,289.133,255,239.64,255,178.2S304.493,67.267,365.933,67.267 S476.867,116.76,476.867,178.2S427.373,289.133,365.933,289.133"/><path d="M365.933,246.467c-37.547,0-68.267-30.72-68.267-68.267s30.72-68.267,68.267-68.267S434.2,140.653,434.2,178.2 S403.48,246.467,365.933,246.467z M365.933,127c-28.16,0-51.2,23.04-51.2,51.2s23.04,51.2,51.2,51.2s51.2-23.04,51.2-51.2 S394.093,127,365.933,127z"/><path d="M186.733,417.133c-24.747,0-46.08-15.36-55.467-38.4l-6.827-17.92l33.28,12.8c14.507,5.12,30.72-0.853,35.84-14.507 c5.12-13.653-3.413-29.013-17.92-34.133l-31.573-13.653l17.067-8.533c7.68-3.413,16.213-5.973,25.6-5.973 c33.28,0,59.733,26.453,59.733,59.733S220.013,417.133,186.733,417.133z M161.987,391.533c6.827,5.12,15.36,8.533,24.747,8.533 c23.893,0,42.667-18.773,42.667-42.667c0-21.333-15.36-39.253-35.84-41.813c15.36,11.947,22.187,31.573,16.213,49.493 C202.947,383.853,182.467,394.093,161.987,391.533z"/><g><path style="fill:#FFFFFF;" d="M193.56,246.467c55.467,3.413,100.693,47.787,104.107,104.107l92.16-64.853 c-6.827,1.707-14.507,2.56-22.187,2.56c-61.44,0-110.933-49.493-110.933-110.933c0-9.387,1.707-18.773,3.413-27.307 L193.56,246.467z"/><path style="fill:#FFFFFF;" d="M186.733,263.533c-20.48,0-37.547,5.12-52.907,16.213l50.347,21.333 c27.307,10.24,42.667,40.107,32.427,66.56c-7.68,20.48-26.453,33.28-49.493,33.28c-6.827,0-12.8-0.853-19.627-3.413 l-52.907-21.333c11.093,41.813,47.787,75.093,92.16,75.093c52.053,0,93.867-41.813,93.867-93.867S238.787,263.533,186.733,263.533 "/><path style="fill:#FFFFFF;" d="M33.133,255L178.2,316.44c19.627,7.68,29.867,27.307,23.04,45.227l0,0 c-6.827,17.92-27.307,26.453-46.933,19.627l-121.173-48.64V255z"/></g></g></svg>]])
svg.Generate("micro_scoreboard_dmenu_copy_model", 16, 16, [[<!-- icon666.com - MILLIONS vector ICONS FREE --><svg version="1.1" id="Capa_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 485.963 485.963" style="enable-background:new 0 0 485.963 485.963;" xml:space="preserve"><g><g><path d="M449.733,119.163l-197.9-117.5c-3.7-2.2-8.3-2.2-12-0.1l-200.6,112.6c-3.7,2.1-6.1,6-6.1,10.3l-2.8,230.1 c-0.1,4.3,2.2,8.2,5.8,10.4l198.9,119.3c1.9,1.1,4,1.7,6.2,1.7c2,0,4-0.5,5.9-1.5l200.7-112.6c3.8-2.1,6.1-6.1,6.1-10.4l1.7-231.9 C455.633,125.263,453.433,121.263,449.733,119.163z M230.933,453.863l-176.6-105.9l2.5-201.8l174.1,102.8V453.863z M243.133,228.263l-174.6-103l177-99.4l174.4,103.5L243.133,228.263z M429.933,354.263l-175,98.2v-203.4l176.5-98.7 L429.933,354.263z"/><path d="M162.633,299.063c2,0,4-0.5,5.9-1.5c5.8-3.3,7.8-10.6,4.6-16.3c-3.2-5.8-10.5-7.8-16.3-4.6c-5.8,3.2-7.8,10.5-4.6,16.3 C154.433,296.863,158.433,299.063,162.633,299.063z"/><path d="M122.533,321.663c2,0,4-0.5,5.9-1.5c5.8-3.2,7.8-10.6,4.6-16.3c-3.2-5.8-10.6-7.8-16.3-4.6c-5.8,3.2-7.8,10.6-4.6,16.3 C114.233,319.463,118.333,321.663,122.533,321.663z"/><path d="M202.833,276.563c2,0,4-0.5,5.9-1.5c5.8-3.2,7.8-10.6,4.6-16.3c-3.2-5.8-10.6-7.8-16.3-4.6c-5.8,3.2-7.8,10.6-4.6,16.3 C194.533,274.363,198.633,276.563,202.833,276.563z"/><path d="M82.433,344.163c2,0,4-0.5,5.9-1.5c5.8-3.3,7.8-10.6,4.6-16.3c-3.3-5.8-10.6-7.8-16.3-4.6c-5.8,3.2-7.8,10.6-4.6,16.3 C74.133,341.963,78.233,344.163,82.433,344.163z"/><path d="M355.533,322.863c1.9,1.1,4,1.7,6.1,1.7c4.1,0,8.1-2.1,10.3-5.9c3.4-5.7,1.5-13.1-4.2-16.4c-5.7-3.4-13.1-1.5-16.5,4.2 C347.933,312.163,349.833,319.463,355.533,322.863z"/><path d="M315.933,299.363c1.9,1.1,4,1.7,6.1,1.7c4.1,0,8.1-2.1,10.3-5.9c3.4-5.7,1.5-13.1-4.2-16.4c-5.7-3.4-13.1-1.5-16.4,4.2 C308.433,288.663,310.233,295.963,315.933,299.363z"/><path d="M276.433,275.863c1.9,1.1,4,1.7,6.1,1.7c4.1,0,8.1-2.1,10.3-5.9c3.4-5.7,1.5-13.1-4.2-16.4c-5.7-3.4-13.1-1.5-16.4,4.2 C268.833,265.163,270.733,272.463,276.433,275.863z"/><path d="M395.133,346.363c1.9,1.1,4,1.7,6.1,1.7c4.1,0,8.1-2.1,10.3-5.9c3.4-5.7,1.5-13.1-4.2-16.5s-13.1-1.5-16.4,4.2 C387.533,335.563,389.433,342.963,395.133,346.363z"/><path d="M244.233,138.063c-6.6-0.1-12.1,5.2-12.1,11.9c-0.1,6.6,5.2,12.1,11.8,12.1c0,0,0.1,0,0.2,0c6.6,0,11.9-5.3,12-11.9 C256.133,143.563,250.833,138.063,244.233,138.063z"/><path d="M244.733,91.963c-6.6-0.1-12.1,5.2-12.1,11.8c-0.1,6.6,5.2,12.1,11.9,12.2h0.1c6.6,0,11.9-5.3,12-11.9 C256.733,97.563,251.433,92.063,244.733,91.963z"/><path d="M245.033,69.963c0,0,0.1,0,0.2,0c6.6,0,11.9-5.3,12-11.9s-5.2-12.1-11.9-12.1c-6.6-0.1-12.1,5.2-12.1,11.8 C233.133,64.463,238.433,69.863,245.033,69.963z"/><path d="M243.633,184.063c-6.6-0.1-12.1,5.2-12.1,11.8c-0.1,6.6,5.2,12.1,11.9,12.2h0.1c6.6,0,11.9-5.3,12-11.9 C255.533,189.563,250.233,184.163,243.633,184.063z"/></g></g></svg>]])
svg.Generate("micro_scoreboard_dmenu_copy_steamid", 16, 16, [[<!-- icon666.com - MILLIONS vector ICONS FREE --><svg version="1.1" id="Capa_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 512 512" style="enable-background:new 0 0 512 512;" xml:space="preserve"><g><g><path d="M239.23,432.257l-15.77-47.309c-5.684-17.051-16.871-31.082-31.193-40.409C203.212,333.663,210,318.611,210,302 c0-33.084-26.916-60-60-60s-60,26.916-60,60c0,16.611,6.788,31.663,17.732,42.538c-14.322,9.327-25.509,23.358-31.193,40.409 l-15.77,47.309C57.537,441.956,64.765,452,75,452h150C235.224,452,242.466,441.966,239.23,432.257z M150,272 c16.542,0,30,13.458,30,30s-13.458,30-30,30s-30-13.458-30-30S133.458,272,150,272z M95.812,422L105,394.434 c6.467-19.4,24.551-32.434,45-32.434c20.449,0,38.533,13.034,45,32.434L204.188,422H95.812z"/></g></g><g><g><path d="M437,332H285c-8.284,0-15,6.716-15,15s6.716,15,15,15h152c8.284,0,15-6.716,15-15S445.284,332,437,332z"/></g></g><g><g><path d="M437,272H285c-8.284,0-15,6.716-15,15s6.716,15,15,15h152c8.284,0,15-6.716,15-15S445.284,272,437,272z"/></g></g><g><g><path d="M315,392h-30c-8.284,0-15,6.716-15,15s6.716,15,15,15h30c8.284,0,15-6.716,15-15S323.284,392,315,392z"/></g></g><g><g><path d="M437,392h-60c-8.284,0-15,6.716-15,15s6.716,15,15,15h60c8.284,0,15-6.716,15-15S445.284,392,437,392z"/></g></g><g><g><circle cx="255" cy="75" r="15"/></g></g><g><g><path d="M437,90H330V75c0-41.355-33.645-75-75-75c-41.355,0-75,33.645-75,75v15H75c-41.355,0-75,33.645-75,75 c0,11.79,0,260.647,0,272c0,41.355,33.645,75,75,75h362c41.355,0,75-33.645,75-75c0-11.278,0-260.24,0-272 C512,123.645,478.355,90,437,90z M210,75c0-24.813,20.187-45,45-45s45,20.187,45,45v45h-90V75z M482,437c0,24.813-20.187,45-45,45 H75c-24.813,0-45-20.187-45-45V210h452V437z M482,180H30v-15c0-24.813,20.187-45,45-45h105v15c0,8.284,6.716,15,15,15h120 c8.284,0,15-6.716,15-15v-15h107c24.813,0,45,20.187,45,45V180z"/></g></g></svg>]])
svg.Generate("micro_scoreboard_dmenu_copy_steamid64", 16, 16, [[<!-- icon666.com - MILLIONS vector ICONS FREE --><svg version="1.1" id="Capa_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 512 512" style="enable-background:new 0 0 512 512;" xml:space="preserve"><g><g><path d="M255,0c-41.353,0-75,33.647-75,75v45h150V75C330,33.647,296.353,0,255,0z M255,90c-8.284,0-15-6.716-15-15s6.716-15,15-15 s15,6.716,15,15S263.284,90,255,90z"/></g></g><g><g><path d="M437,90h-77v45c0,8.291-6.709,15-15,15H165c-8.291,0-15-6.709-15-15V90H75c-41.353,0-75,33.647-75,75v15h512v-15 C512,123.647,478.353,90,437,90z"/></g></g><g><g><path d="M195,394.432C188.525,375.037,170.449,362,150,362c-20.449,0-38.525,13.037-45,32.432L95.815,422h108.369L195,394.432z"/></g></g><g><g><path d="M150,272c-16.538,0-30,13.462-30,30c0,16.538,13.462,30,30,30c16.538,0,30-13.462,30-30C180,285.462,166.538,272,150,272z "/></g></g><g><g><path d="M0,210v227c0,41.353,33.647,75,75,75h362c41.353,0,75-33.647,75-75V210H0z M237.173,445.774 C234.346,449.686,229.819,452,225,452H75c-4.819,0-9.346-2.314-12.173-6.226c-2.812-3.911-3.589-8.95-2.051-13.52l15.776-47.314 c5.686-17.073,16.99-30.959,31.337-40.283C96.865,333.771,90,318.685,90,302c0-33.091,26.909-60,60-60s60,26.909,60,60 c0,16.685-6.865,31.771-17.889,42.656c14.346,9.324,25.651,23.21,31.337,40.283l15.776,47.314 C240.762,436.823,239.986,441.862,237.173,445.774z M317,422h-30c-8.291,0-15-6.709-15-15c0-8.291,6.709-15,15-15h30 c8.291,0,15,6.709,15,15C332,415.291,325.291,422,317,422z M437,422h-60c-8.291,0-15-6.709-15-15c0-8.291,6.709-15,15-15h60 c8.291,0,15,6.709,15,15C452,415.291,445.291,422,437,422z M437,362H287c-8.291,0-15-6.709-15-15c0-8.291,6.709-15,15-15h150 c8.291,0,15,6.709,15,15C452,355.291,445.291,362,437,362z M437,302H287c-8.291,0-15-6.709-15-15c0-8.291,6.709-15,15-15h150 c8.291,0,15,6.709,15,15C452,295.291,445.291,302,437,302z"/></g></g></svg>]])
svg.Generate("micro_scoreboard_dmenu_copy_accountid", 16, 16, [[<!-- icon666.com - MILLIONS vector ICONS FREE --><svg version="1.1" id="Capa_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 512 512" style="enable-background:new 0 0 512 512;" xml:space="preserve"><g><g><rect y="81" width="512" height="42.667"/></g></g><g><g><path d="M0,153.667v81.667h512v-81.667H0z M296.694,215.713L275.48,194.5l21.214-21.213l21.213,21.213L296.694,215.713z M354.24,215.713L333.027,194.5l21.213-21.213l21.213,21.213L354.24,215.713z M411.787,215.713L390.573,194.5l21.214-21.213 L433,194.5L411.787,215.713z"/></g></g><g><g><path d="M0,265.334V431h512V265.334H0z M224,356.333H85.333v-30H224V356.333z"/></g></g></svg>]])
svg.Generate("micro_scoreboard_dmenu_copy_userid", 16, 16, [[<!-- icon666.com - MILLIONS vector ICONS FREE --><svg id="Layer_5" enable-background="new 0 0 64 64" viewBox="0 0 64 64" xmlns="http://www.w3.org/2000/svg"><g><path d="m21.157 34c.38-1.157 1.458-2 2.741-2h4.205c1.282 0 2.36.843 2.741 2h.156c.267 0 .522.046.768.112.147-.504.232-1.027.232-1.553 0-3.065-2.494-5.559-5.559-5.559h-.882c-3.065 0-5.559 2.494-5.559 5.559 0 .525.085 1.048.232 1.553.246-.066.501-.112.768-.112z"/><path d="m28.806 45.148-.034-.006c-.451 1.089-1.522 1.858-2.772 1.858s-2.321-.769-2.771-1.858l-.034.006c-2.182.364-3.995 1.857-4.832 3.852h15.274c-.837-1.995-2.65-3.488-4.831-3.852z"/><path d="m21 38v-2c-.551 0-1 .449-1 1s.449 1 1 1z"/><path d="m34 5c1.13 0 2.162.391 3 1.026v-.026c0-1.654-1.346-3-3-3h-4c-1.654 0-3 1.346-3 3v.026c.838-.635 1.87-1.026 3-1.026z"/><path d="m31 36v2c.551 0 1-.449 1-1s-.449-1-1-1z"/><path d="m25 15h-15c-.551 0-1 .449-1 1v1h16z"/><path d="m37 10c0-1.654-1.346-3-3-3h-4c-1.654 0-3 1.346-3 3v7h10zm-5 4c-1.105 0-2-.895-2-2s.895-2 2-2 2 .895 2 2-.895 2-2 2z"/><path d="m54 15h-15v2h16v-1c0-.551-.449-1-1-1z"/><path d="m9 60c0 .551.449 1 1 1h44c.551 0 1-.449 1-1v-41h-46zm7-2h-4v-4h4zm8 0h-4v-4h4zm8 0h-4v-4h4zm8 0h-4v-4h4zm8 0h-4v-4h4zm5-15h-6v-2h6zm-9-21h8v8h-8zm-1 11h10v2h-10zm0 4h10v2h-10zm0 4h2v2h-2zm0 4h10v2h-10zm0 4h10v2h-10zm-32-28h30v30h-30z"/><path d="m13 49h3.246c.925-3.002 3.481-5.302 6.619-5.825l.324-.054.127-.506c-1.068-.5-1.872-1.454-2.173-2.615h-.143c-1.654 0-3-1.346-3-3 0-.628.196-1.211.527-1.693-.341-.874-.527-1.81-.527-2.748 0-4.168 3.391-7.559 7.559-7.559h.882c4.168 0 7.559 3.391 7.559 7.559 0 .939-.186 1.875-.527 2.748.332.483.527 1.065.527 1.693 0 1.654-1.346 3-3 3h-.142c-.302 1.161-1.106 2.115-2.173 2.615l.127.507.324.054c3.138.523 5.694 2.823 6.619 5.825h3.245v-26.001h-26z"/><path d="m25.014 44.068c.037.518.459.932.986.932s.949-.414.986-.932l-.267-1.068h-1.438z"/><path d="m25 41h2c1.103 0 2-.897 2-2v-4.103c0-.494-.403-.897-.897-.897h-4.205c-.495 0-.898.403-.898.897v4.103c0 1.103.897 2 2 2z"/></g></svg>]])
svg.Generate("micro_scoreboard_dmenu_goto", 16, 16, [[<!-- icon666.com - MILLIONS vector ICONS FREE --><svg id="Layer_1" viewBox="0 0 512 512" xmlns="http://www.w3.org/2000/svg" data-name="Layer 1"><path d="m309.5 62.014 202.5 116.913-202.5 116.913v-86.8h-158.912a90.353 90.353 0 0 0 0 180.706h240.942v60.236h-240.942a150.589 150.589 0 0 1 0-301.177h158.912z" fill-rule="evenodd"/></svg>]])
svg.Generate("micro_scoreboard_dmenu_bring", 16, 16, [[<!-- icon666.com - MILLIONS vector ICONS FREE --><svg viewBox="-33 -141 1065.0001 1065" xmlns="http://www.w3.org/2000/svg"><path d="m679.929688 141.726562h-440.1875v-150.5l-241.761719 241.773438 241.761719 241.761719v-155.546875h440.1875c76.644531 0 139.003906 62.359375 139.003906 139.003906 0 76.648438-62.359375 139-139.003906 139h-501.996094v177.488281h501.996094c174.511718 0 316.488281-141.972656 316.488281-316.488281s-141.976563-316.492188-316.488281-316.492188zm0 0"/></svg>]])
svg.Generate("micro_scoreboard_dmenu_kick", 16, 16, [[<!-- icon666.com - MILLIONS vector ICONS FREE --><svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 512 512" style="enable-background:new 0 0 512 512;" xml:space="preserve"><g><g><path d="M324.364,291.484v-86.36H50.909v281.242c0,14.158,11.478,25.635,25.636,25.635h393.091 c14.158,0,25.636-11.477,25.636-25.636C495.273,386.674,420.675,304.082,324.364,291.484z"/></g></g><g><g><path d="M332.909,0H42.363C28.205,0,16.727,11.478,16.727,25.636v102.546c0,14.16,11.478,25.636,25.636,25.636h8.545v0.032 h273.455v-0.032h8.545c14.158,0,25.636-11.477,25.636-25.636V25.636C358.546,11.478,347.067,0,332.909,0z"/></g></g></svg>]])

local function CreateMenuPanel(ply)
	Menu = DermaMenu(false)
	Menu:SetDeleteSelf(true)
	local CopySubMenu, CopyMenu = Menu:AddSubMenu("Copy")
	CopyMenu:SetMaterial(svg.Cache["micro_scoreboard_dmenu_copy"].mat)

	CopySubMenu:AddOption("Name", function() SetClipboardText(ply:Name()) end):SetMaterial(svg.Cache["micro_scoreboard_dmenu_copy_name"].mat)
	CopySubMenu:AddOption("Profile URL", function() SetClipboardText("http://steamcommunity.com/profiles/" .. ply:SteamID64()) end):SetMaterial(svg.Cache["micro_scoreboard_dmenu_copy_button_profile_url"].mat)
	CopySubMenu:AddOption("Model", function() SetClipboardText(ply:GetModel()) end):SetMaterial(svg.Cache["micro_scoreboard_dmenu_copy_model"].mat)
	CopySubMenu:AddSpacer()
	CopySubMenu:AddOption("SteamID", function() SetClipboardText(ply:SteamID()) end):SetMaterial(svg.Cache["micro_scoreboard_dmenu_copy_steamid"].mat)
	CopySubMenu:AddOption("SteamID64", function() SetClipboardText(ply:SteamID64()) end):SetMaterial(svg.Cache["micro_scoreboard_dmenu_copy_steamid64"].mat)
	CopySubMenu:AddOption("AccountID", function() SetClipboardText(ply:AccountID()) end):SetMaterial(svg.Cache["micro_scoreboard_dmenu_copy_accountid"].mat)
	CopySubMenu:AddOption("UserID", function() SetClipboardText(ply:EntIndex()) end):SetMaterial(svg.Cache["micro_scoreboard_dmenu_copy_userid"].mat)

	if ctrl and LocalPlayer() ~= ply then
		Menu:AddSpacer()
		local target = ply:Name()


		if LocalPlayer():IsAdmin() then
			local SubMenu, ParentMenu = Menu:AddSubMenu("Go To", function() ctrl.CallCommand(LocalPlayer(), "goto", {target}, target) end)
			ParentMenu:SetMaterial(svg.Cache["micro_scoreboard_dmenu_goto"].mat)
			SubMenu:AddOption("Bring", function() ctrl.CallCommand(LocalPlayer(), "bring", {target}, target) end):SetMaterial(svg.Cache["micro_scoreboard_dmenu_bring"].mat)

			Menu:AddOption("Kick", function() ctrl.CallCommand(LocalPlayer(), "kick", {target}, target) end):SetMaterial(svg.Cache["micro_scoreboard_dmenu_kick"].mat)
		else
			Menu:AddOption("Go To", function() ctrl.CallCommand(LocalPlayer(), "goto", {target}, target) end):SetMaterial(svg.Cache["micro_scoreboard_dmenu_goto"].mat)
		end
	end
	Menu:AddSpacer()
	local MicVolume = Menu:Add("DSlider")
	MicVolume:SetTall(22)
	MicVolume:SetSlideX(ply:GetVoiceVolumeScale())
	MicVolume.Knob.Paint = function() end
	MicVolume.OnValueChanged = function(self, x, y)
		ply:SetVoiceVolumeScale(x)
	end
	MicVolume.Paint = function(self, w, h)
		surface.SetDrawColor(PlayerVolumeColor)
		surface.DrawRect(2, 2, w * self:GetSlideX() - 4, h - 4)
		draw.SimpleText("Voice Volume", "DermaDefault", w / 2, h / 2, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	Menu:AddPanel(MicVolume)
	Menu:Open()

	return Menu
end

local ms_player_panels = {}
function PANEL:Init()
	self.id = table.insert(ms_player_panels, self)
	self:SetTall(20)
	self:SetText("")
	self:DockMargin(0, 0, 0, 3)
	self.lastClicked = UnPredictedCurTime()

	self.avatarPicture = self:Add("AvatarImage")
	self.avatarPicture:Dock(LEFT)
	self.avatarPicture:SetSize(20, 20)

	self.buttonProfile = self.avatarPicture:Add("DButton")
	self.buttonProfile:SetText("")
	self.buttonProfile:Dock(FILL)
	self.buttonProfile.Paint = nil
	self.hovered = self:IsHovered() or self:IsChildHovered()

	self.RankPadding = 0
end

function PANEL:DoClick()
	if self.ply == LocalPlayer() then return end
	if not ctrl then return end

	local target = self.ply:Name()
	ctrl.CallCommand(LocalPlayer(), "goto", {target}, target)
end

function PANEL:DoRightClick()
	MICRO_SCOREBOARD.Menu = CreateMenuPanel(self.ply)
end

function PANEL:SetPlayer(ply)
	self.ply = ply

	self.avatarPicture:SetPlayer(ply, 64)

	self.buttonProfile.DoRightClick = function()
		MICRO_SCOREBOARD.Menu = CreateMenuPanel(ply)
	end
	self.gradientColor = GAMEMODE:GetTeamColor(ply)
	self.gradientColor.a = 100

	self.buttonProfile.DoClick = function() self.ply:ShowbuttonProfile() end
	self.buttonProfileTooltip = self.buttonProfile:Add("MS_TooltipImage")
	self.buttonProfileTooltip:SetPlayer(self.ply)
	self.buttonProfile:SetTooltipPanel(self.buttonProfileTooltip)

	if not ply:IsBot() then
		self.Flag = self:Add("DImageButton")
		self.Flag:SetSize(16, 12)
		self.Flag:DockMargin(0, 4, 42, 4)
		self.Flag:Dock(RIGHT)
		self.Flag:SetImage("materials/flags16/" .. ply:nw3GetString("country_code") .. ".png")
		self.Flag:SetDepressImage(false)
		self.Flag:SetTooltip(ply:nw3GetString("country", "N/A"))
		self.Flag:SetTooltipPanelOverride("MS_Tooltip")
	end

	--Ranks
	local Rank = RankImage[ply:GetUserGroup()]
	if not Rank then return end

	self.Rank = self:Add("DButton")
	self.Rank:SetText("")
	self.Rank:SetSize(16, 16)
	self.Rank:DockMargin(2, 2, 0, 2)
	self.Rank:Dock(LEFT)
	self.Rank:SetTooltip(Rank.Tooltip)
	self.Rank:SetTooltipPanelOverride("MS_Tooltip")
	self.Rank.Paint = function()
		svg.Draw(RankImage[ply:GetUserGroup()]["Icon"], 0, 0)
	end

	self.RankPadding = 14
end

function PANEL:GetPlayerID()
	if not IsValid(self.ply) then return end

	return self.ply:EntIndex()
end

function PANEL:UpdateFlag(flag)
	self.Flag:SetImage("materials/flags16/" .. flag .. ".png")
end

function PANEL:UpdateCountryName(name)
	self.Flag:SetTooltip(name)
end

function PANEL:Paint(w, h)
	if not IsValid(self.ply) then
		self:Remove()
		MICRO_SCOREBOARD.Scoreboard:UpdateSize(player.GetCount())
		return
	end

	local ply = self.ply
	--Background Color
	for k ,v in pairs(self:GetChildren()) do
		local hover = v:IsHovered()
		self.hovered = hover
		if hover then break end
	end

	local timeout
	if not ply:IsBot() then timeout = ply:nw3GetBool("IsTimingOut") end

	self.hovered = self:IsHovered() or self:IsChildHovered()
	surface.SetDrawColor(timeout and MICRO_SCOREBOARD.Player_Timeout_BGColor or MICRO_SCOREBOARD.Player_BGColor)
	surface.DrawRect(0, 0, w, h)

	if self.hovered then
		surface.SetDrawColor(timeout and MICRO_SCOREBOARD.Player_Timeout_BGColor_Hovered or MICRO_SCOREBOARD.Player_BGColor_Hovered)
		surface.SetMaterial(gradient_up)
		surface.DrawTexturedRect(0, 0, w, h)
	end

	--Text
	draw.SimpleText(ply:Name(), "micro_scoreboard_player_panel_16", 25 + self.RankPadding, 10, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

	draw.SimpleText(ply:IsBot() and "BOT" or ply:Ping(), "micro_scoreboard_player_panel_16", w - 5, 10, MICRO_SCOREBOARD.Player_PingColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

	if ply:IsBot() then return end
	local playtime = ply:nw3GetInt("Playtime") + (CurTime() - ply:nw3GetInt("Joined"))

	local format = "h"
	if playtime < 3600 then
		playtime = math.floor(playtime / 60)
		format = "m"
	elseif playtime < 36000 then
		playtime = math.Round(playtime / 3600, 1)
	else
		playtime = math.floor(playtime / 3600)
	end
	draw.SimpleText(playtime .. format, "micro_scoreboard_player_panel_16", w - 80, 10, color_black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

	svg.Draw("MS_Clock", w - 76, 3)
end

function PANEL:OnRemove()
	table.remove(ms_player_panels, self.id)
end

hook.Add("OnNW3ReceivedEntityValue", "MICRO_SCOREBOARDboard_flag_update", function(entindex, _, id, var)
	if id ~= "country" and id ~= "country_code" then return end

	timer.Simple(0, function()
		for i = 1, #ms_player_panels do
			local pnl = ms_player_panels[i]
			if pnl:GetPlayerID() ~= entindex then continue end

			if id == "country_code" then
				pnl:UpdateFlag(var)
			elseif id == "country" then
				pnl:UpdateCountryName(var)
			end
			break
		end
	end)
end)

vgui.Register("MS_PlayerInfo", PANEL, "DButton")
